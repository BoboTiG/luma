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
    && ufw allow 9000/udp \
    && ufw enable \
    && echo 'OK'


apt install -y jq net-tools unzip
curl -sL https://github.com/dusk-network/node-installer/releases/download/v0.5.2/node-installer.sh | bash


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
    && source ~/.profile

echo "${RUSK_WALLET_PWD}" \
    && echo 'OK'

curl -s 'http://127.0.0.1:8080/02/Chain' \
    --data-raw '{"topic":"gql","data":"query{block(height:-1){header{height}}}"}' \
    | jq '.block.header.height'

curl -s 'https://api.dusk.network/v1/stats' | jq '.lastBlock'
rusk-wallet stake --amt AMOUNT
rusk-wallet unstake \
    && rusk-wallet stake --amt AMOUNT

rusk-wallet --state 'http://127.0.0.1:8080' balance

echo 'Y' | ruskreset \
    && service rusk start \
    && echo 'OK'

source ~/.profile

cat << 'EOF' >> ~/.profile

# Dusk
function grep_logs() {
    local color
    local idx
    local pattern
    local round

    if [ "${1:-accepted-only}" = "accepted-only" ]; then
        pattern='0'
        color=42
    else
        pattern='[[:digit:]]'
        color=43
    fi

    idx=1
    zgrep 'Block generated' /var/log/rusk.log* \
        | awk '{print $4 $5}' \
        | sed 's/[[:cntrl:]]\[[[:digit:]][a-z]//g' \
        | grep -E "iter=${pattern}" | \
            while read -r line ; do \
                round="$(echo "${line}" | grep -Eo 'round=[[:digit:]]+' | cut -d= -f2)"
                printf '\e[30;1;%dm %d \e[0m %s\n' ${color} ${idx} "${round}"
                idx=$(( idx + 1 ))
            done
}

function blocks() {
    local c="$(ruskquery block-height)"
    local l="$(API_ENDPOINT=https://nodes.dusk.network ruskquery block-height)"
    local a="$(accepted | wc -l)"
    local g="$(generated | wc -l)"
    local r=$(echo "scale=2 ; $a / $g * 100" | bc)
    # printf '[%d/%d] %d|%d (%s%%)\n' $l $c $g $a $r
    printf '[\e[34m%d\e[0m/\e[31m%d\e[0m] \e[33m%d\e[0m|\e[32m%d\e[0m (\e[39m%s%%\e[0m)\n' $l $c $g $a $r
}

alias accepted='grep_logs accepted-only'
alias balance='rusk-wallet balance --spendable'
alias generated='grep_logs all'
alias logs='tail -f /var/log/rusk.log'
alias rewards='rusk-wallet stake-info --reward'
alias stake-info='rusk-wallet stake-info'
EOF
