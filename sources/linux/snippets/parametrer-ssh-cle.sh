#!/bin/bash

ssh-keygen -t ed25519
chmod 0600 ~/.ssh/id_ed25519

cat << EOF >> ~/.ssh/config
Host machine
    User alice
    HostName example.org|example.local|IP
    Port 22
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_ed25519
EOF

mkdir -p ~/.ssh && chmod 0700 ~/.ssh
echo '<id_ed25519.pub>' >> ~/.ssh/authorized_keys
chmod 0644 ~/.ssh/authorized_keys

lastb | head
service ssh status

find /etc/ssh -type f -print0 | xargs -0 \
    sed -i 's/#*[[:space:]]*PasswordAuthentication[[:space:]]*yes/PasswordAuthentication no/'
service ssh restart
