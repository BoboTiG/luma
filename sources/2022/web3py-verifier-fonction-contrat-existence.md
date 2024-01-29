# Python, Web3 : Déterminer si un contrat contient une fonction donnée

Fonction bien utile qui renverra `True` si une fonction donnée est présente dans un contrat :

```{code-block} python
from eth_hash.auto import keccak

def has_function(contract_addr: str, signature: str) -> bool:
    code = w3.eth.get_code(contract_addr).hex()
    fn_hash = keccak(signature.encode()).hex()
    fn_hash = f"63{fn_hash[:8]}"  # 0x63 is PUSH4
    return fn_hash in code
```

Utilisation :

```{code-block} python
>>> contract_addr = "0x00e1656e45f18ec6747F5a8496Fd39B50b38396D"  # random
>>> has_function(contract_addr, "transfer(address,uint256)")
True
>>> has_function(contract_addr, "rugMeDaddy(address)")
False
```

Nada !

[Version anglaise](https://ethereum.stackexchange.com/a/123607/95322) très courte.

---

## Historique

- 2024-01-27 : Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2022/03/11/17/29/46-python-web3-determiner-si-un-contrat-contient-une-fonction-donnee).
- 2022-04-23 : Code plus rapide et supportant Web3.py v6+
  ```{code-block} diff

  +from eth_hash.auto import keccak
  +
   def has_function(contract_addr: str, signature: str) -> bool:
       code = w3.eth.get_code(contract_addr).hex()
  -    fn_hash = w3.keccak(signature.encode()).hex()
  -    fn_hash = f"63{fn_hash[2:10]}"  # 0x63 is PUSH4
  +    fn_hash = keccak(signature.encode()).hex()
  +    fn_hash = f"63{fn_hash[:8]}"  # 0x63 is PUSH4
       return fn_hash in code
  ```
  - Avant : `0,0677` sec
  - Après : `0,0256` sec (- 62,2 %)
- 2022-03-11 : Premier jet.