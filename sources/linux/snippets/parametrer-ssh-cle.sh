#!/bin/bash

ssh-keygen -t ed25519
chmod 0600 ~/.ssh/id_ed25519

cat << EOF >> ~/.ssh/config
Host machine
    User alice
    HostName example.org|example.local|IP
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_ed25519
EOF

mkdir -p ~/.ssh && chmod 0700 ~/.ssh
echo '<id_ed25519.pub>' >> ~/.ssh/authorized_keys
chmod 0644 ~/.ssh/authorized_keys

lastb | head
service ssh status

# Si fail2ban est installé et activé
fail2ban-client status sshd
sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 "SELECT COUNT(*) from bips WHERE jail = 'sshd'"

find /etc/ssh -type f -print0 | xargs -0 \
    sed -i 's/#*[[:space:]]*PasswordAuthentication[[:space:]]*yes/PasswordAuthentication no/'
service ssh restart

cat << EOF
[DEFAULT]

# Banni pendant 24h...
bantime = 24h
# ... Suite à la première tentative.
maxretry = 1

[sshd]

mode    = aggressive
port    = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
EOF
