#!/bin/bash

# Today's timestamp
current_date=$(date -d "00:00" +%s)

# For each tag …
while IFS= read -r tag; do
    # ${tag} syntax is "name date"
    release_version="$(echo "${tag}" | cut -d' ' -f1)"
    release_date=$(date -d "$(echo "${tag}" | cut -d' ' -f2)"  +%s)

    # The number of days between today and when the tag was created
    days=$(( (current_date - release_date) / (24 * 3600) ))

    if [ ${days} -gt 21 ]; then
        git tag --delete "${release_version}"
        git push --delete origin "${release_version}" 
    fi
done < <(git for-each-ref --sort=-taggerdate --format '%(refname:short) %(taggerdate:short)' refs/tags \
    | grep -E "(^alpha*)")
