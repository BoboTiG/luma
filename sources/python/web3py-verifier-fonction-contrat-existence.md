# Python, Web3 : Déterminer si un contrat contient une fonction donnée

Fonction bien utile qui renverra `True` si une fonction donnée est présente dans un contrat :

```{literalinclude} snippets/web3py-verifier-fonction-contrat-existence.py
    :lines: 1-11
    :language: python
```

Utilisation :

```{literalinclude} snippets/web3py-verifier-fonction-contrat-existence.py
    :lines: 16-20
    :dedent:
    :language: python
```

[Version anglaise](https://ethereum.stackexchange.com/a/123607/95322) très courte.

---

## 📜 Historique

2024-01-27
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2022/03/11/17/29/46-python-web3-determiner-si-un-contrat-contient-une-fonction-donnee).

2022-04-23
: Code plus rapide et supportant Web3.py v6+ :

  ```{literalinclude} snippets/web3py-verifier-fonction-contrat-existence.diff
    :language: diff
  ```

- Avant : `0,0677` sec
- Après : `0,0256` sec (- 62,2 %)

2022-03-11
: Premier jet.
