#!/bin/bash

pdftk \
    'FILE_SOURCE.pdf' \
    cat \
    1-300 \
    301-303left \
    304-end \
    output \
    'NEW_FILE.pdf'

grep --text MediaBox 'FILE_SOURCE.pdf' | sort -u
sed 's/MediaBox \[0 0 595.*/MediaBox \[0 0 612 792\]/g' \
    'FILE_SOURCE.pdf' \
    > 'NEW_FILE.pdf'

pdftk \
    'FILE_SOURCE_1.pdf' \
    'FILE_SOURCE_2.pdf' \
    cat \
    output \
    'NEW_FILE.pdf'

gs \
    -o 'FILE_SOURCE.pdf' \
    -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/prepress \
    -dEmbedAllFonts=true \
    -sFONTPATH='./pdf-fonts' \
    'NEW_FILE.pdf'

gs \
    -o 'FILE_SOURCE.pdf' \
    -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/prepress \
    -dEmbedAllFonts=true \
    'NEW_FILE.pdf'

pdftk 'FILE_SOURCE.pdf' dump_data_utf8 output 'metadata.txt'
pdftk 'FILE_SOURCE.pdf' update_info_utf8 'metadata.txt' output 'NEW_FILE.pdf'

pdftk 'FILE_SOURCE.pdf' input_pw PROMPT output 'NEW_FILE.pdf'

pdftk 'FILE_SOURCE.pdf' cat 2-5 output 'NEW_FILE.pdf'
