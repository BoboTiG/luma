#!/bin/bash

user='user'
password='password'
ip='127.0.0.1'
url='/live/0/mjpeg.jpg'

stream="http://${user}:${password}@${ip}${url}"

while true; do
    for n in $(seq 10 -1 1); do
        clear
        echo "Vidéo dans ${n}s…"
        sleep 1
    done

    omxplayer -o hdmi \
        --no-osd \
        --no-keys \
        --aidx -1 \
        --refresh \
        --live \
        "${stream}"
done

sudo apt install omxplayer

omxplayer -o hdmi URL

user='admin'
password='password'
ip='192.168.0.24'
url='/video/mjpg.cgi?profileid=2'

# (…)
sh /opt/stream-hdmi.sh &

@reboot USER sh /opt/stream-hdmi.sh &

# (…)
sh /opt/stream-hdmi.sh &
exit 0
