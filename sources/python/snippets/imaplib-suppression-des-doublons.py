import re
from getpass import getpass
from imaplib import IMAP4_SSL as IMAP
from socket import gaierror

PATTERN_MSG_ID = re.compile(rb"Message-ID: (<[^>]+>)").search
PATTERN_UID = re.compile(rb"UID (\d+)").search


def get_emails(conn: IMAP) -> list[str]:
    """Récupérer la liste des identifiants uniques (UID) des messages."""

    # On cherche les messages marqués comme "non supprimés"
    ret, uids = conn.uid("search", "", "UNDELETED")
    return [uid.decode() for uid in uids[0].split()] if ret == "OK" else []


def get_folder(raw_line: bytes | None) -> str:
    r"""
    Détermine le dossier depuis les données renvoyées par la fonction IMAP.

    >>> get_folder(None)
    ''
    >>> get_folder(b'(\\Noselect) "/" "Perso"')
    ''
    >>> get_folder(b'() "/" "inbox"')
    '"inbox"'
    >>> get_folder(b'() "/" "[Gmail]/Tous les messages"')
    '"[Gmail]/Tous les messages"'
    """
    # Certains dossiers ne sont pas sélectionnables
    if not raw_line or b"Noselect" in raw_line:
        return ""

    folder = raw_line.decode().split('"')[3]

    # Il faut échapper le nom du dossier par des double-quotes pour éviter les erreurs.
    # Ça protège les noms de dossier qui contiennent des espaces.
    return f'"{folder}"'


def get_msg_id(raw_line: bytes) -> str:
    r"""
    Détermine le Message-ID depuis les données renvoyées par la fonction IMAP.

    >>> get_msg_id(b"\r\n")
    ''
    >>> get_msg_id(b"Message-ID: \r\n")
    ''
    >>> get_msg_id(b"Message-ID: something\r\n")
    ''
    >>> get_msg_id(b"Message-ID: <CACqWxT1rjTZ7Y-43F=nWUfMa5pkRB5VJSFUkhuRtsE4a9da2Rw@mail.gmail.com>\r\n")
    '<CACqWxT1rjTZ7Y-43F=nWUfMa5pkRB5VJSFUkhuRtsE4a9da2Rw@mail.gmail.com>'
    """
    return msg_id[1].decode() if (msg_id := PATTERN_MSG_ID(raw_line)) else ""


def get_uid(raw_line: bytes) -> str:
    """
    Détermine l'UID du message depuis les données renvoyées par la fonction IMAP.

    >>> get_uid(b"2 (UID 15309 BODY[HEADER.FIELDS (MESSAGE-ID)] {82}")
    '15309'
    """
    return uid[1].decode() if (uid := PATTERN_UID(raw_line)) else ""


def purge(conn: IMAP, folder: str) -> None:
    """Supprimer les doublons dans un dossier."""

    print(">>>", folder.strip('"'))

    # Et on se rend dans ledit dossier
    ret, data = conn.select(folder)
    if ret != "OK":
        raise IMAP.error(ret)

    # Récupérer la liste des courriels
    if not (uids := get_emails(conn)):
        return

    print(f"{len(uids):>6} messages")

    # Recherchons les doublons
    uniq_msgs: set[str] = set()
    duplicates: set[str] = set()

    # La méthode `IMAP.uid()` peut traiter plusieurs messages à la fois, ce qui économise
    # temps et ressources. On concatène tous les UID des messages avec une virgule.
    # Le gain de temps est phénoménal.
    all_uids = ",".join(sorted(uids))

    # On ne récupère que l'entête Message-ID de chaque message, universellement unique.
    # `BODY.PEEK` permet de ne pas modifier l'état du message, sinon le message serait marqué comme lu.
    ret, data = conn.uid("fetch", all_uids, "(BODY.PEEK[HEADER.FIELDS (MESSAGE-ID)])")
    if ret != "OK":
        raise IMAP.error(ret)

    # `data` est une liste contenant UID, taille et Message-ID, entre autres.
    # Pour chaque message…
    for line in data:
        if not isinstance(line, tuple):
            continue
        data_uid, data_msg_id = line

        # Il se peut que le message n'aie pas de Message-ID, c'est souvent le cas
        # de ceux envoyés par la fonction PHP `mail()` ou Python `smtplib`.
        # Du coup, on zappe. Pour y remédier, voyez l'avertissement sur la page de l'article :
        #     https://www.tiger-222.fr/luma/python/imaplib-suppression-des-doublons.html
        if not (msg_id := get_msg_id(data_msg_id)):
            continue

        # Si le Message-ID a déjà été traité, alors il s'agit d'un doublon…
        if msg_id in uniq_msgs:
            # … et on ajoute son UID à la liste des messages à supprimer
            duplicates.add(get_uid(data_uid))
        else:
            uniq_msgs.add(msg_id)

    # Suppression des doublons
    if duplicates:
        print(f"{len(duplicates):>6} doublons")
        all_uids = ",".join(sorted(duplicates))
        conn.uid("store", all_uids, "+FLAGS", "\\Deleted")

    conn.close()


def main(server: str, user: str) -> int:
    password = getpass()

    # Connexion au serveur de messagerie
    try:
        conn = IMAP(server)
        conn.login(user, password)
    except (OSError, gaierror, IMAP.error) as ex:
        print(ex)
        return 1

    # On fait le ménage dans tous les dossiers
    ret, data = conn.list()
    if ret != "OK":
        print(ret)
        return 1

    try:
        for infos in data:
            assert isinstance(infos, bytes)  # Pour Mypy
            if folder := get_folder(infos):
                purge(conn, folder)
    except IMAP.error as ex:
        print(ex)
        return 1

    conn.logout()
    return 0


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print(f"python {sys.argv[0]} SERVER USER")
        sys.exit(1)

    sys.exit(main(sys.argv[1], sys.argv[2]))
