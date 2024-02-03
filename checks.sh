#!/bin/bash
set -eu

FOLDER='sources'

# Python scripts
python -m ruff format "${FOLDER}"
python -m ruff --fix "${FOLDER}"
python -m mypy "${FOLDER}"

# Shell scripts
/bin/find "${FOLDER}" -type f -name '*.sh' -exec shellcheck -e SC1091,SC2164 {} \;
shellcheck 'checks.sh'  # This file ^^

# Markdown files
python -m pymarkdown --disable-rules line-length fix -r "${FOLDER}"
python -m pymarkdown --disable-rules line-length scan -r "${FOLDER}"
python -m pymarkdown --disable-rules line-length scan -r 'README.md'

# Spelling (requires the `aspell-fr` package to be installed)
/bin/find "${FOLDER}" -type f -name '*.md' -exec aspell --home-dir='.' --mode='markdown' --lang='fr' --dont-backup check {} \;
aspell --home-dir='.' --mode='markdown' --lang='fr' --dont-backup check 'README.md'
