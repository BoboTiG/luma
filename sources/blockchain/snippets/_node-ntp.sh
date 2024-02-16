#!/bin/bash

timedatectl
timedatectl set-timezone Europe/Paris

apt install -y chrony \
    && echo 'OK'

chronyc tracking
