# Python et IMAP : Suppression des doublons

Script utile pour supprimer les messages en double/triple voire plus.

## 🎩 Le Script

```{literalinclude} snippets/imaplib-suppression-des-doublons.py
:caption: imap-delete-duplicates.py
:language: python
```

## 📺 Utilisation

Et voici ce que ça donne en situation réelle :

```{code-block} shell
python imap-delete-duplicates.py 'mail.gandi.net' 'test@jmsinfo.co'
```

```{code-block} text
:caption: Exemple de sortie
Password:
>>> Drafts
>>> Trash
    45 messages
>>> Sent
    37 messages
     1 doublons
>>> INBOX
   888 messages
   443 doublons
>>> INBOX/Droit du travail
     2 messages
```

Et avec une boîte de messagerie contenant plusieurs dizaines de millers de messages :

```{code-block} shell
time python imap-delete-duplicates.py 'imap.gmail.com' 'test@gmail.com'
```

```{code-block} text
:caption: Exemple de sortie
Password:
>>> Archives
 10792 messages
     9 doublons
>>> INBOX
  6550 messages
     3 doublons
>>> Personnel
     4 messages
>>> Re&AOc-us
>>> [Gmail]/Billetterie
    36 messages
>>> [Gmail]/Brouillons
>>> [Gmail]/Clef GNUPG
>>> [Gmail]/Corbeille
    37 messages
>>> [Gmail]/Important
  6153 messages
     2 doublons
>>> [Gmail]/Messages envoy&AOk-s
  8684 messages
>>> [Gmail]/Spam
  1169 messages
>>> [Gmail]/Suivis
    22 messages
>>> [Gmail]/Tous les messages
 25970 messages
    12 doublons

8,64s user 0,16s system 7% cpu 1:55,36 total
```

## 📧 Message-ID

Parfois, un message n’aura pas le Message-ID dans ses entêtes. Assuez-vous d’utiliser ces morceaux de code lorsque vous envoyez des courriels.

### 🐍 Python

Pour ajouter le bon Message-ID aux courriels envoyés par les functions du module {py:mod}`smtplib` :

```{code-block} python
from email.utils import make_msgid

msg["Message-ID"] = make_msgid()
```

### 🐘 PHP

Pour ajouter le bon Message-ID aux courriels envoyés par la fonction [`mail()`](https://www.php.net/manual/fr/function.mail.php) :

```{literalinclude} snippets/imaplib-suppression-des-doublons.php
:lines: 2-
:dedent:
:language: php
```

---

## 🎣 Sources

- [What’s the issue with `Message-Id` in email sent by PHP?](https://stackoverflow.com/q/14483861/1117028)

## 📜 Historique

2024-10-31
: Utilisation de regexps pour trouver les Message-ID et UID d’un courriel.
: Refactorisation de la partie appelant `main()`.

2024-10-29
: Revue de code pour supprimer les commentaires `type: ignore[…]`, moderniser, et corriger/retester l’ensemble.
: Ajout des sections.

2024-02-01
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2016/02/05/18/00/41-imaplib-suppression-des-doublons).

2016-02-08
: Optimisation et correction, certains dossiers sont inaccessibles ("[Gmail]" par exemple).

2016-02-05
: Premier jet.
