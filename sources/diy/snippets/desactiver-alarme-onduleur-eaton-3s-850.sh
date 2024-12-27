#!/bin/bash

sudo apt install libusb-1.0-0 nut

sudo nut-scanner

printf 'MODE=standalone\n' | sudo tee /etc/nut/nut.conf > /dev/null

echo 'maxretry = 3

[eaton]
    driver = usbhid-ups
    port = auto
    vendorid = 0463 
' | sudo tee /etc/nut/ups.conf > /dev/null

echo '[admin]
    password = password
    actions = set
    actions = fsd
    instcmds = all
' | sudo tee /etc/nut/upsd.users > /dev/null

sudo service nut-server restart

upsc eaton ups.beeper.status

upsc eaton

sudo upscmd -u admin -p password eaton beeper.disable
