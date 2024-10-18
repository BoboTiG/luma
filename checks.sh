#!/bin/bash
set -eu

FOLDER='sources'

check_python_files() {
    python -m ruff format "${FOLDER}" ./*.py
    python -m ruff check --fix "${FOLDER}" ./*.py
    python -m mypy "${FOLDER}" ./*.py
}

check_shell_file() {
    shellcheck -e SC1091,SC2164 "${1}"
}

check_shell_files() {
    for file in $(/bin/find "${FOLDER}" -type f -name '*.sh'); do
        check_shell_file "${file}"
    done
    check_shell_file 'checks.sh'
}

check_markdown_file() {
    local file="${1}"
    shift

    python -m pymarkdown fix "${file}"
    python -m pymarkdown "$@" scan "${file}"
}

check_markdown_files() {
    local disabled_rules
    local filename

    check_markdown_file 'README.md'

    for file in $(/bin/find "${FOLDER}" -type f -name '*.md'); do
        disabled_rules=()
        if [ "$(dirname "${file}")" = "sources/inipi" ]; then
            filename="$(basename "${file}")"
            [ "${filename:0:1}" = '_' ] || disabled_rules=(-d 'md003,md022,md041')
        fi
        check_markdown_file "${file}" "${disabled_rules[@]}"
    done
}

check_yaml_file() {
    python -m yamllint -s -d relaxed "${1}"
}

check_yaml_files() {
    check_yaml_file "${FOLDER}"
    check_yaml_file '.github'
}

main() {
    check_python_files
    check_shell_files
    check_markdown_files
    check_yaml_files
}

main
exit 1
