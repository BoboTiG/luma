#!/bin/bash

# System packages
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
    && dpkg -l | grep -Ec '^ii'  # 457

# Network stack
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
net.core.netdev_max_backlog = 2000
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.rmem_max = 50000000
net.core.wmem_max = 50000000
net.ipv4.tcp_mem = 50576 64768 98152
net.ipv4.tcp_rmem = 4096 87380 50000000
net.ipv4.tcp_wmem = 4096 65536 50000000
net.ipv4.tcp_low_latency = 1
EOF
cat << 'EOF' >> /etc/netplan/50-cloud-init.yaml
      mtu: 9000
      routes:
      - to: default
        via: 95.179.176.1
      - to: 169.254.0.0/16
        via: 95.179.176.1
        metric: 100
EOF

# Other optimizations
sed -i 's/typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)/typeset -g POWERLEVEL9K_VCS_BACKENDS=()/' ~/.p10k.zsh \
    && systemctl disable rsyslog.service \
    && systemctl disable motd-news.timer

# Dusk
cat << 'EOF' > ~/perfs.sh
#!/bin/bash

sed -i 's/mtu = [0-9]*/mtu = 8192/' /opt/dusk/conf/rusk.toml \
    && sed -i 's/udp_recv_buffer_size = [0-9]*/udp_recv_buffer_size = 50000000/' /opt/dusk/conf/rusk.toml \
    && sed -i 's/max_inv_entries = [0-9]*/max_inv_entries = 500/' /opt/dusk/conf/rusk.toml \
    && sed -i 's/max_udp_len = [0-9]*/max_udp_len = 20971520/' /opt/dusk/conf/rusk.toml
EOF
