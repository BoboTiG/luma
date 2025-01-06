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
curl -sL https://github.com/dusk-network/node-installer/releases/download/v0.5.3/node-installer.sh | bash


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

apt install btop \
    && apt purge \
        apache2-utils \
        apport \
        appstream \
        apt-utils \
        bash-completion \
        binutils \
        bolt \
        bpfcc-tools \
        bpftrace \
        btrfs-progs \
        byobu \
        cloud-guest-utils \
        cmake \
        cracklib-runtime \
        dbus \
        dosfstools \
        eject \
        git \
        javascript-common \
        keyboxd \
        krb5-locales \
        man-db \
        manpages-dev \
        mawk \
        motd-news-config \
        nftables \
        parted \
        patch \
        pinentry-curses \
        python3-botocore \
        python3-click \
        python3-dev \
        python3-gi \
        python3-idna \
        python3-jwt \
        python3-markdown-it \
        python3-pip \
        python3-pyinotify \
        python3-pyrsistent:amd64 \
        python3-serial \
        python3-twisted \
        sosreport \
        strace \
        sudo \
        systemd-timesyncd \
        tmux \
        ubuntu-pro-client \
        ubuntu-release-upgrader-core \
        ubuntu-standard \
        vim-common \
        wamerican \
        x11proto-dev \
        xauth \
        zstd \
    && apt autoremove \
    && sed -i 's/typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)/typeset -g POWERLEVEL9K_VCS_BACKENDS=()/' ~/.p10k.zsh \
    && dpkg -l | grep -Ec '^ii'  # 457

cat << 'EOF' > /etc/sysctl.conf
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_congestion_control = htcp
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.lo.rp_filter = 1
# TODO: adapt ethernet device below
net.ipv4.conf.enp1s0.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.lo.accept_source_route = 0
# TODO: adapt ethernet device below
net.ipv4.conf.enp1s0.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.ip_forward = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 1000
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_mem = 50576 64768 98152
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_low_latency = 1
EOF




















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
    # printf '[%d/%d] %d|%d (%s%%)\n' $c $l $g $a $r
    printf '[\e[34m%d\e[0m/\e[31m%d\e[0m] \e[33m%d\e[0m|\e[32m%d\e[0m (\e[39m%s%%\e[0m)\n' $c $l $g $a $r
}

alias accepted='grep_logs accepted-only'
alias balance='rusk-wallet balance --spendable'
alias generated='grep_logs all'
alias logs='tail -f /var/log/rusk.log'
alias rewards='rusk-wallet stake-info --reward'
alias stake-info='rusk-wallet stake-info'
EOF
