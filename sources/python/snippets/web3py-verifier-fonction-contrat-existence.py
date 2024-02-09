from eth_hash.auto import keccak
from web3 import HTTPProvider, Web3

W3 = Web3(HTTPProvider("RPC_URL"))


def has_function(contract_addr: str, signature: str) -> bool:
    code = W3.eth.get_code(contract_addr).hex()
    fn_hash = keccak(signature.encode()).hex()
    fn_hash = f"63{fn_hash[:8]}"  # 0x63 is PUSH4
    return fn_hash in code


def check() -> None:
    """
    >>> contract_addr = "0x00e1656e45f18ec6747F5a8496Fd39B50b38396D"  # random
    >>> has_function(contract_addr, "transfer(address,uint256)")
    True
    >>> has_function(contract_addr, "rugMeDaddy(address)")
    False
    """
