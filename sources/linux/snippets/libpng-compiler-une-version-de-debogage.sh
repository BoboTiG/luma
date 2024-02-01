#!/bin/bash

git clone --depth=1 'https://github.com/pnggroup/libpng.git' \
    && cd libpng

./autogen.sh \
    && ./configure CPPFLAGS=-DPNG_DEBUG=2 \
    && make -j

./pngtest --strict IMAGE
