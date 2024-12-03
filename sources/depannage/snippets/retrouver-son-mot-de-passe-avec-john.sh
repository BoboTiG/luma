#!/bin/bash

git clone https://github.com/openwall/john -b bleeding-jumbo --depth=1 \
    && cd john

cd src \
    && ./configure \
    && make clean \
    && make -s \
    && cd ../run

./unshadow 'path/to/passwd' 'path/to/shadow' > ~/unshadowed.txt

./john \
    --mask='[jJ][vV][dD]@?1?1?1?1' \
    -1='[0-9]' \
    ~/unshadowed.txt
