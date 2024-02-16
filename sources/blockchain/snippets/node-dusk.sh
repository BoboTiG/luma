#!/bin/bash

cat << EOF >> ~/.ssh/config
Host dusk
    User root
    HostName ADRESSE_IP
    Port 22
EOF

apt update \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && reboot

apt install -y ufw \
    && ufw allow ssh \
    && ufw allow 8080/tcp \
    && ufw allow 9000/udp \
    && ufw enable \
    && echo 'OK'

curl --proto '=https' --tlsv1.2 -sSfL https://github.com/dusk-network/itn-installer/releases/download/v0.1.0/itn-installer.sh | bash \
    && echo 'OK'

rusk-wallet restore

rusk-wallet export -d /opt/dusk/conf -n consensus.keys

/opt/dusk/bin/setup_consensus_pwd.sh

service rusk start

grep 'block accepted' /var/log/rusk.log | tail -1

rusk-wallet balance --spendable
rusk-wallet stake --amt 1000
rusk-wallet stake-info
rusk-wallet stake-info --reward

tail -F /var/log/rusk.log | grep 'execute_state_transition'
grep 'execute_state_transition' /var/log/rusk.log
grep -A 100 -C 100 'execute_state_transition' /var/log/rusk.log | sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g'

service rusk stop \
    && rm -rvf /opt/dusk/rusk/chain.db \
    && rm -rvf /opt/dusk/rusk/state \
    && rm -rvf ~/.dusk/rusk-wallet/cache \
    && service rusk start \
    && echo 'OK'
