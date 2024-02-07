#!/bin/bash

git log \
    | grep -e 'Author:' -e 'Co-authored-by:' \
    | sed 's/Author: // ; s/Co-authored-by: // ; s/^ *// ; s/ <.*//' \
    | sort -u
