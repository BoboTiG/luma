#!/bin/bash

identify -quiet -ping -format '%m %w %h %z %[colorspace]' 'FILE.png'
# PNG 42 42 8 sRGB

pngfix 'FILE.png'
# IDAT OK  default 15 15 28 5334 FILE.png
