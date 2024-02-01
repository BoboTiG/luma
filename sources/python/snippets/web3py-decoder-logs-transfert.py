from web3 import HTTPProvider, Web3
from web3.logs import DISCARD

# Note: I picked a random transaction, this is not my wallet!
MY_ADDRESS = "0xDA9f28a1b0CE18b011A404f3372d98C3E3143569"
TX_HASH = "0x5270f284b2a5432e264be7a173fd5f187983a86d80e7f65cf2e9125b7fde1e51"

AVALANCHE_MAINNET_RPC_URL = "https://api.avax.network/ext/bc/C/rpc"
TRADER_JOE_ROUTER_ADDRESS = "0x60aE616a2155Ee3d9A68541Ba4544862310933d4"

# We will check both wallet, and router, addresses to catch coins transfers too (USDC.e -> AVAX for example)
ADDRESSES = {MY_ADDRESS, TRADER_JOE_ROUTER_ADDRESS}

MINIMAL_ABI = [
    # Transfer event
    {
        "name": "Transfer",
        "type": "event",
        "anonymous": False,
        "inputs": [
            {"indexed": True, "name": "from", "type": "address"},
            {"indexed": True, "name": "to", "type": "address"},
            {"indexed": False, "name": "value", "type": "uint256"},
        ],
    },
]

# Initiate the machine
w3 = Web3(HTTPProvider(AVALANCHE_MAINNET_RPC_URL))

# Instantiate the router
router = w3.eth.contract(address=TRADER_JOE_ROUTER_ADDRESS, abi=MINIMAL_ABI)

# Get the transaction receipt
receipt = w3.eth.get_transaction_receipt(TX_HASH)

# Decode logs, without displaying warnings about discarded logs
logs = router.events.Transfer().processReceipt(receipt, errors=DISCARD)

# 1. Access details as simply as:
print("Details:")
for idx, log in enumerate(logs, start=1):
    args = log.args
    print(f"  {idx}. From {args['from']} to {args['to']} for {args['value']} tokens")

# 2. Or compute amounts
tokens_sent = sum(log.args["value"] for log in logs if log.args["from"] in ADDRESSES)
tokens_received = sum(log.args["value"] for log in logs if log.args["to"] in ADDRESSES)

# You will need to adapt "10**N" with the real token decimals
print("\nAmounts:")
print(f"  - Tokens sent    : {tokens_sent / 10**18:.5f} $WETH.e")
print(f"  - Tokens received: {tokens_received / 10**9:.5f} $TIME")
