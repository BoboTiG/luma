#!/bin/bash

apt update \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && apt install -y unattended-upgrades \
    && reboot
