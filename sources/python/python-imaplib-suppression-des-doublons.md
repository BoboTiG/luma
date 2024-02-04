# Python et IMAP : suppression des doublons

Commençons par nous connecter à la boîte de messagerie :

```{todo}
Supprimer les commentaires `type: ignore[...]` et corriger/retester le code.
```

```{literalinclude} snippets/python-imaplib-suppression-des-doublons.py
    :caption: imap-delete-duplicate.py
    :lines: 1-124
    :language: python
```

Et voici ce que ça donne en situation réelle :

```{code-block} text
    :caption: $ python imap-delete-duplicate.py 'mail.gandi.net' 'test@jmsinfo.co'

Password:
Drafts
Trash
    45 messages
Sent
    37 messages
     1 doublons
INBOX
   888 messages
   443 doublons
INBOX/Droit du travail
     2 messages
```

Et avec une grosse boîte de messagerie :

```{code-block} text
    :caption: $ time python imap-delete-duplicate.py 'imap.gmail.com' 'test@gmail.com'

Password:
Archives
 10792 messages
     9 doublons
INBOX
  6550 messages
     3 doublons
Personnel
     4 messages
Re&AOc-us
[Gmail]/Billetterie
    36 messages
[Gmail]/Brouillons
[Gmail]/Clef GNUPG
[Gmail]/Corbeille
    37 messages
[Gmail]/Important
  6153 messages
     2 doublons
[Gmail]/Messages envoy&AOk-s
  8684 messages
[Gmail]/Spam
  1169 messages
[Gmail]/Suivis
    22 messages
[Gmail]/Tous les messages
 25970 messages
    12 doublons

8,64s user 0,16s system 7% cpu 1:55,36 total
```

````{note}
Pour ajouter le bon Message-ID aux courriels envoyés par les functions du module {py:mod}`smtplib` de Python :

```{literalinclude} snippets/python-imaplib-suppression-des-doublons.py
    :lines: 129-130
    :dedent:
    :language: python
```
````

````{note}
Pour ajouter le bon Message-ID aux courriels envoyés par la fonction [`mail()`](https://www.php.net/manual/function.mail.php) de PHP :

```{literalinclude} snippets/python-imaplib-suppression-des-doublons.php
    :lines: 2-
    :dedent:
    :language: php
```
````

---

## 🎣 Sources

- [What's the issue with `Message-Id` in email sent by PHP?](https://stackoverflow.com/q/14483861/1117028)

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2016/02/05/18/00/41-python-imaplib-suppression-des-doublons).

2016-02-08
: Optimisation et correction, certains dossiers sont inaccessibles ("[Gmail]" par exemple).

2016-02-05
: Premier jet.
