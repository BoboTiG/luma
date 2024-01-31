"""Tool to get the private key of a keystore file."""
import sys
from binascii import b2a_hex
from pathlib import Path

from web3.auto import w3

path = Path(__file__).parent / "node" / "keystore" / sys.argv[1]
encrypted_key = path.read_text()
password = ""  # Adapt accordingly to what was set at the account creation
private_key = w3.eth.account.decrypt(encrypted_key, password)
print(b2a_hex(private_key).decode())
