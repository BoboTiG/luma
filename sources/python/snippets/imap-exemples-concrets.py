from datetime import datetime
from imaplib import IMAP4_SSL as IMAP
from socket import gaierror

# Configuration
server = "mail.gandi.net"
user = "username@domain"
password = "password"

# Connexion au serveur
try:
    conn = IMAP(server)
    conn.login(user, password)
    conn.select()
except gaierror:
    # Le serveur est erroné ou injoignable
    raise
except IMAP.error:
    # Problème d'identification !
    # L'utilisateur et mot de passe sont-ils corrects ?
    raise

ret, data = conn.uid("search", "", "(UNSEEN)")
if ret == "OK":
    uids = data[0].split()

for uid in uids:
    ret, data = conn.uid("fetch", uid, "(BODY[TEXT])")
    if ret == "OK":
        body = data[0][1]

conn.uid("store", uid, "+FLAGS", "(\\Seen)")

conn.uid("store", ",".join(uids), "+FLAGS", "(\\Seen)")

conn.uid("store", uid, "-FLAGS", "(\\Seen)")

ret, data = conn.uid("search", "", '(UNSEEN SUBJECT "Foo bar")')
if ret == "OK":
    uids = data[0].split()

ret, data = conn.uid("search", "", '(FROM "alice@example.org")')
if ret == "OK":
    uids = data[0].split()

ret, data = conn.uid("search", "", '(TO "bob@example.org")')
if ret == "OK":
    uids = data[0].split()

ret, data = conn.uid("search", "", '(FROM "alice@example.org" TO "bob@example.org")')
if ret == "OK":
    uids = data[0].split()

day = "2016-09-06"
since = datetime.strptime(day, "%Y-%m-%d").astimezone().strftime("%d-%b-%Y")
look_for = f'(SENTSINCE {since} SUBJECT "Foo bar")'
ret, data = conn.uid("search", "", look_for)
if ret == "OK":
    uids = data[0].split()

ret, data = conn.uid("search", "", '(X-GM-RAW "has:attachment")')
if ret == "OK":
    uids = data[0].split()

conn.uid("store", uids, "+FLAGS", "\\Deleted")
conn.expunge()

folder = "archives-personal"
conn.uid("copy", uids, folder)

ret, data = conn.uid("fetch", uids, "(BODY.PEEK[HEADER.FIELDS (MESSAGE-ID)])")
if ret == "OK":
    uids = data[0].split()
