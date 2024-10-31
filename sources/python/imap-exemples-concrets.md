# Python et IMAP : Exemples concrets

Commençons par nous connecter à la boîte de messagerie :

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 2-21
:language: python
```

```{tip}
{py:func}`imaplib.IMAP4.select` permet de sélectionner le *dossier* où sont stockés les messages. Par défaut, on ne passe aucun argument, mais pour Gmail, on pourrait utiliser `conn.select("Inbox")`{l=python}.
```

Nous allons maintenant récupérer les identifiants des messages non lus. Pour faire les choses correctement, nous utiliserons la commande {py:func}`imaplib.IMAP4.uid` qui fonctionne avec des identifiants uniques pour chaque message.

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 23-25
:language: python
```

`uids` contiendra, par exemple, `[b'9263', b'9264', b'9265']`{l=python}.

Pour finir, avec ces identifiants, téléchargeons le contenu des messages :

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 27-30
:language: python
```

```{attention}
Du moment que la commande {py:func}`imaplib.IMAP4.fetch` est utilisée, le message concerné est marqué comme lu.
Afin de ne pas modifier l’état du message, préférer les commandes `(BODY.PEEK[HEADER])` ou encore `(BODY.PEEK[TEXT])` (et plus généralement [`BODY.PEEK[<section>]<<partial>>`](https://www.rfc-editor.org/rfc/rfc3501#page-57)).
```

---

## Commandes en Vrac

### Marquer un message comme lu

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 32
:language: python
```

### Marquer plusieurs messages comme lus

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 34
:language: python
```

### Marquer un message comme non lu

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 36
:language: python
```

### Récupérer seulement l’UID des messages sans modifier l’état

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 71-73
:language: python
```

### Récupérer les messages non lus et ayant un sujet particulier

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 38-40
:language: python
```

### Récupérer les messages d’un certain émetteur

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 42-44
:language: python
```

### Récupérer les messages pour un certain destinataire

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 46-48
:language: python
```

### Récupérer les messages d’un certain émetteur pour un certain destinataire

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 50-52
:language: python
```

### Récupérer les messages à partir d’une certaine date et ayant un sujet particulier

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 1,53-59
:language: python
```

### Gmail : récupérer les messages contenant une pièce jointe

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 61-63
:language: python
```

### Supprimer un ou plusieurs messages

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 65-66
:language: python
```

### Copier un ou plusieurs messages

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 68-69
:language: python
```

### Déplacer un ou plusieurs messages

La commande `MOVE` n’existe pas ; pour l’émuler, if faut faire une copie puis supprimer les originaux :

```{literalinclude} snippets/imap-exemples-concrets.py
:lines: 68-69,65-66
:language: python
```

---

## 🎣 Sources

- [Python — imaplib IMAP example with Gmail](https://yuji.wordpress.com/2011/06/22/python-imaplib-imap-example-with-gmail/)

## 📜 Historique

2024-10-29
: Ajout de plus d’informations dans l’avertissement quant à l’état du message après utilisation de la commande {py:func}`imaplib.IMAP4.fetch`.
: Ajout de l’exemple [Récupérer seulement l’UID des messages sans modifier l’état](#recuperer-seulement-l-uid-des-messages-sans-modifier-l-etat).

2024-02-01
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2016/01/21/16/35/09-imap-exemple-concret).

2018-09-23
: Ajout de l’exemple [Supprimer un ou plusieurs messages](#supprimer-un-ou-plusieurs-messages).
: Ajout de l’exemple [Copier un ou plusieurs messages](#copier-un-ou-plusieurs-messages).
: Ajout de l’exemple [Déplacer un ou plusieurs messages](#deplacer-un-ou-plusieurs-messages).

2016-09-06
: Ajout de l’exemple [Marquer plusieurs messages comme lus](#marquer-plusieurs-messages-comme-lus).
: Ajout de l’exemple [Récupérer les messages d’un certain émetteur](#recuperer-les-messages-d-un-certain-emetteur).
: Ajout de l’exemple [Récupérer les messages pour un certain destinataire](#recuperer-les-messages-pour-un-certain-destinataire).
: Ajout de l’exemple [Récupérer les messages d’un certain émetteur pour un certain destinataire](#recuperer-les-messages-d-un-certain-emetteur-pour-un-certain-destinataire).
: Ajout de l’exemple [Récupérer les messages à partir d’une certaine date et ayant un sujet particulier](#recuperer-les-messages-a-partir-d-une-certaine-date-et-ayant-un-sujet-particulier).
: Ajout de l’exemple [Gmail : récupérer les messages contenant une pièce jointe](#gmail-recuperer-les-messages-contenant-une-piece-jointe).

2016-01-21
: Premier jet.
