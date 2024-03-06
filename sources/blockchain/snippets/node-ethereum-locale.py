"""Tool to get the private key of a keystore file.

Setup:
python -m pip install eth-account
"""

import sys
from binascii import b2a_hex
from pathlib import Path

from eth_account.account import Account

path = Path(__file__).parent / "node" / "keystore" / sys.argv[1]
encrypted_key = path.read_text()
password = ""  # Adapt accordingly to what was set at the account creation
private_key = Account.decrypt(encrypted_key, password)
print(b2a_hex(private_key).decode())
