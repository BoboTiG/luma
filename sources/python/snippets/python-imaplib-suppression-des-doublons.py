from getpass import getpass
from imaplib import IMAP4_SSL as IMAP
from socket import gaierror


def get_emails(conn: IMAP) -> list[str]:
    """Récupérer la liste des identifiants uniques (UID) des messages."""

    emails = []
    # On cherche les messages marqués comme "non supprimés"
    ret, uids = conn.uid("search", "", "UNDELETED")
    if ret == "OK":
        emails = uids[0].split()
    return emails


def purge(conn: IMAP, folder: str) -> None:
    """Supprimer les doublons dans un dossier."""

    print(folder)
    # Il faut entourer le nom du dossier par des double-quotes pour éviter les erreurs.
    # Ça protège les noms de dossier qui contiennent des espaces.
    path = f'"{folder}"'
    # Et on se rend dans ledit dossier
    ret, data = conn.select(path)
    if ret != "OK":
        raise IMAP.error(ret)

    # Récupérer la liste des courriels
    uids = get_emails(conn)
    total = len(uids)
    if not total:
        return

    print(f"{total:>6} messages")

    # Recherchons les doublons
    uniq_msgs = []
    duplicata = []
    # La méthode IMAP.uid() peut traiter plusieurs messages à la fois, ce qui économise
    # temps et ressources. On concatène tous les UID des messages avec une virgule.
    # Le gain de temps est phénoménal.
    all_uids = ",".join(uids)
    # On ne récupère que le champ Message-ID de chaque message, universellement unique.
    # BODY.PEEK permet de ne pas modifier l'état du message.
    # Sinon, le message serait marqué comme lu.
    ret, data = conn.uid("fetch", all_uids, "(BODY.PEEK[HEADER.FIELDS (MESSAGE-ID)])")
    if ret != "OK":
        raise IMAP.error(ret)

    # data est une liste contenant UID, taille et Message-ID, entre autres.
    # Pour chaque message...
    for idx in range(0, len(data), 2):
        # Il se peut que le message n'aie pas de Message-ID, c'est souvent le cas
        # de ceux envoyés par la fonction PHP mail() ou Python smtplib.
        # Du coup, on zappe. Pour y remédier, voyez en bas de page.
        if not data[idx][1].strip():  # type: ignore[index,union-attr]
            continue

        # On en déduit le Message-ID
        msg_id = data[idx][1].split(" ")[1].replace("\r\n", "")  # type: ignore[index,union-attr]

        # Si le Message-ID a déjà été traité, alors il s'agit d'un doublon
        if msg_id in uniq_msgs:
            # On ajoute son UID à la liste des messages à supprimer
            uid = data[idx][0].split()[2]  # type: ignore[index,union-attr]
            duplicata.append(uid)
        else:
            uniq_msgs.append(msg_id)

    # Suppression des doublons
    if duplicata:
        print(f"{len(duplicata):>6} doublons")
        # Idem, en faisant une seule requête contenant tous les messages à supprimer,
        # le gain de temps est énorme.
        all_uids = ",".join(duplicata)
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
        # Pour chaque dossier...
        for infos in data:
            # infos contient plusieurs informations plus ou moins utiles.
            # Cependant, certains dossiers ne sont pas sélectionnables, on zappe.
            if "Noselect" in infos:  # type: ignore[operator]
                continue

            # On ne prend que ce qui nous intéresse, le nom du dossier.
            folder = str(infos).split('"')[3]
            purge(conn, folder)
    except IMAP.error as ex:
        print(ex)
        return 1

    conn.logout()
    return 0


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("python IMAP-delete-duplicate.py SERVER USER")
        exit(1)

    exit(main(sys.argv[1], sys.argv[2]))


def msg_id() -> None:
    """
    >>> from email.utils import make_msgid
    >>> msg["Message-ID"] = make_msgid()
    """
