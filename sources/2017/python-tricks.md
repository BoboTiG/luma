# Python tricks

## {py:func}`format`

Vous pouvez spécifier un séparateur des milliers pour {py:func}`format` :

```{literalinclude} snippets/python-tricks.py
    :lines: 7-10
    :dedent:
    :language: python
```

Idem pour les {py:obj}`f-string` :

```{literalinclude} snippets/python-tricks.py
    :lines: 11-14
    :dedent:
    :language: python
```

---

## {py:func}`pow`

{py:func}`pow` peut prendre un 3{sup}`ème` argument pour calculer `pow(x, y) % z`{l=python} :

```{literalinclude} snippets/python-tricks.py
    :lines: 19-25
    :language: python
```

---

## {py:func}`re.sub`

{py:func}`re.sub` peut être utilisée pour remplacer plusieurs caractères dans un texte (évitant ainsi d'avoir à enchaîner les appels à {py:obj}`str.replace` ou au plus coûteux {py:obj}`str.translate`) :

```{literalinclude} snippets/python-tricks.py
    :lines: 1,3,28-30
    :language: python
```

````{admonition} Benchmark
    :class: dropdown

Code :

```{literalinclude} snippets/python-tricks.py
    :caption: bench.py
    :lines: 1,31-62
    :language: python
```

Résultats :

```{code-block} shell
    :caption: $ python3.8 bench.py

0.041965347016230226  # str.replace()
0.10586143494583666  # re.sub()
0.2713684451300651  # str.translate()
```

````

---

## {py:obj}`str.startswith` & {py:obj}`str.endswith`

{py:obj}`str.startswith` et {py:obj}`str.endswith` peuvent prendre un {py:obj}`tuple` en paramètre :

```{literalinclude} snippets/python-tricks.py
    :lines: 65-80
    :language: python
```

````{admonition} Benchmark
    :class: dropdown

Résultats :

```{code-block} shell
# text = 'azerty', the 1st condition is True
Option 1: 0.171 usec
Option 2: 0.174 usec

# text = 'czerty',  the last condition is True
Option 1: 0.498 usec
Option 2: 0.200 usec

# text = 'nzerty', all conditions are False
Option 1: 0.472 usec
Option 2: 0.186 usec
```

````

---

## {py:mod}`time` & {py:mod}`datetime`

Vous pouvez supprimer les zéros ajoutés pour les différentes fonctions du module {py:mod}`time` qui prennent un format en entrée (valable pour {py:mod}`datetime` également) :

```{literalinclude} snippets/python-tricks.py
    :lines: 85-90
    :dedent:
    :language: python
```

---

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2017/10/09/09/46/44-python-tricks).

2019-12-13
: Ajout de [`re.sub()`](#re-sub).

2019-04-19
: Ajout de [`format()`](#format).

2017-12-06
: Ajout de [`time` & `datetime`](#time-datetime).

2017-10-09
: Premier jet avec [`str.startswith()` & `str.endswith()`](#str-startswith-str-endswith) et [`pow()`](#pow), mieux vaut publier maintenant que jamais ☺
