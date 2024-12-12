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
    && ufw limit ssh \
    && ufw allow 8080/tcp \
    && ufw allow 9000/udp \
    && ufw enable \
    && echo 'OK'

apt install -y jq net-tools unzip \
    && curl -sL https://github.com/dusk-network/node-installer/releases/download/v0.4.0/node-installer.sh | sh \
    && echo 'OK'

rusk-wallet restore

rusk-wallet export -d /opt/dusk/conf -n consensus.keys \
    && echo "DUSK_CONSENSUS_KEYS_PASS=${RUSK_WALLET_PWD}" > /opt/dusk/services/dusk.conf


service rusk start

tail -f /var/log/rusk.log

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

lsof -i -P -n
ufw status verbose

echo "export RUSK_WALLET_PWD='MOT_DE_PASSE_DU_WALLET'" >> ~/.profile \
    && source "${HOME}/.profile"

echo "${RUSK_WALLET_PWD}" \
    && echo 'OK'

curl -s 'http://127.0.0.1:8080/02/Chain' \
    --data-raw '{"topic":"gql","data":"query{block(height:-1){header{height}}}"}' \
    | jq '.block.header.height'

curl -s 'https://api.dusk.network/v1/stats' | jq '.lastBlock'

rusk-wallet unstake \
    && rusk-wallet stake --amt AMOUNT

rusk-wallet --state 'http://127.0.0.1:8080' balance

cat << EOF >> ~/.profile

# Dusk specific commands
alias balance='rusk-wallet balance --spendable'
alias blocks='echo "Current: \$(current)" ; echo "Latest : \$(latest)"'
alias chosen='zgrep execute_state_transition /var/log/rusk.log-*.gz ; grep execute_state_transition /var/log/rusk.log'
alias current='curl -s http://127.0.0.1:8080/02/Chain --data-raw '"'"'{"topic":"gql","data":"query{block(height:-1){header{height}}}"}'"'"' | jq .block.header.height'
alias latest='ruskquery block-height'
alias logs='tail -f /var/log/rusk.log'
alias rewards='rusk-wallet stake-info --reward'
alias stake-info='rusk-wallet stake-info'
EOF
source "${HOME}/.profile"

echo 'Y' | ruskreset \
    && service rusk start \
    && echo 'OK'

# install rusk
# apt install clang gcc git libssl-dev make pkg-config rustc \
#     && git clone https://github.com/dusk-network/rusk.git \
#     && echo 'OK'

# compiler
# [Option, select a commit or tagged release]

# cd rusk \
#     && rm -rfv target \
#     && make keys wasm \
#     && cargo b --release -p rusk \
#     && target/release/rusk --version \
#     && read -p 'Continue (CTRL+C to cancel)? ' \
#     && service rusk stop \
#     && mv -v /opt/dusk/bin/rusk/opt/dusk/bin/rusk.old \
#     && cp -v target/release/rusk /opt/dusk/bin/rusk \
#     && service rusk start \
#     && echo 'OK'

# installer rusk-wallet
