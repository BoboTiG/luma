#!/bin/bash
set -eu

FOLDER='sources'

check_python_files() {
    python -m ruff format "${FOLDER}"
    python -m ruff --fix "${FOLDER}"
    python -m mypy "${FOLDER}"
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

check_spelling_file() {
    # Requires the `aspell-fr` package to be installed
    aspell --home-dir='.' --mode='markdown' --lang='fr' --dont-backup check "${1}"
}

check_spelling_files() {
    for file in $(/bin/find "${FOLDER}" -type f -name '*.md'); do
        check_spelling_file "${file}"
    done
    check_spelling_file 'README.md'
}

main() {
    check_python_files
    check_shell_files
    check_markdown_files
    check_spelling_files
}

main
