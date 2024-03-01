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
    python -m pymarkdown --disable-rules line-length fix -r "${1}"
    python -m pymarkdown --disable-rules line-length scan -r "${1}"
}

check_markdown_files() {
    check_markdown_file "${FOLDER}"
    check_markdown_file 'README.md'
}

check_yaml_file() {
    yamllint -d relaxed "${1}"
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
