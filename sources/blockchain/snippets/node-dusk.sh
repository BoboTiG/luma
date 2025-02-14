#!/bin/bash

cat << 'EOF' >> ~/.ssh/config
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
    && ufw limit ssh \
    && ufw allow 9000/udp \
    && ufw enable \
    && echo 'OK'


apt install -y jq net-tools unzip
curl -sL https://github.com/dusk-network/node-installer/releases/download/v0.5.4/node-installer.sh | bash


rusk-wallet restore

rusk-wallet export -d /opt/dusk/conf -n consensus.keys \
    && echo "DUSK_CONSENSUS_KEYS_PASS=${RUSK_WALLET_PWD}" > /opt/dusk/services/dusk.conf
zgrep WARN /var/log/rusk*.log
zgrep ERROR /var/log/rusk*.log
service rusk start

tail -f /var/log/rusk.log
rusk-wallet withdraw [--amt AMOUNT]
rusk-wallet balance --spendable
rusk-wallet stake --amt 1000
rusk-wallet stake-info
rusk-wallet stake-info --reward

tail -F /var/log/rusk.log | grep 'execute_state_transition'
zgrep 'execute_state_transition' /var/log/rusk.log*
grep -A 100 -C 100 'execute_state_transition' /var/log/rusk.log | sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g'

service rusk stop \
    && rm -rvf /opt/dusk/rusk/chain.db \
    && rm -rvf /opt/dusk/rusk/state \
    && rm -rvf ~/.dusk/rusk-wallet/cache \
    && service rusk start \
    && echo 'OK'

lsof -i -P -n
ufw status verbose

echo "export RUSK_WALLET_PWD='MOT_DE_PASSE_DU_WALLET'" >> ~/.profile \
    && source ~/.profile

echo "${RUSK_WALLET_PWD}" \
    && echo 'OK'

curl -s 'http://127.0.0.1:8080/02/Chain' \
    --data-raw '{"topic":"gql","data":"query{block(height:-1){header{height}}}"}' \
    | jq '.block.header.height'

curl -s 'https://api.dusk.network/v1/stats' | jq '.lastBlock'
rusk-wallet stake --amt AMOUNT
rusk-wallet unstake [--amt AMOUNT] \
    && rusk-wallet stake --amt AMOUNT

rusk-wallet --state 'http://127.0.0.1:8080' balance

echo 'Y' | ruskreset \
    && service rusk start \
    && echo 'OK'

source ~/.profile

cat << 'EOF' >> ~/.profile

# Dusk
alias balance='rusk-wallet balance --spendable 2>/dev/null'
alias logs='tail -f /var/log/rusk.log'
alias rewards='rusk-wallet stake-info --reward 2>/dev/null'
alias stake-info='rusk-wallet stake-info 2>/dev/null'
EOF
