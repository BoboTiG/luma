# Générer des images PNG

Voici une fonction bien pratique pour créer une image au format PNG. La valeur ajoutée ici, c’est qu’on utilise seulement du Python pur, sans passer par de module tierce.

## Imports

```{literalinclude} snippets/generer-image-png.py
:caption: generer-image-png.py
:lines: 1-4
:language: python
```

## La fonction

```{literalinclude} snippets/generer-image-png.py
:caption: generer-image-png.py
:pyobject: generate_random_png
:language: python
```

## Validation

Pour vérifier la validité des fichiers générés :

```{literalinclude} snippets/generer-image-png.sh
:lines: 3-4
:language: shell
```

```{literalinclude} snippets/generer-image-png.sh
:lines: 6-7
:language: shell
```

---

## 📜 Historique

2024-02-07
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2017/04/13/10/20/59-creer-des-images-png-valides-pour-vos-tests).

2017-05-17
: Le fichier généré contenait une erreur `IDAT:_uncompressed_data_too_small`.
: Ajout des commandes de [vérification](#validation).

2017-04-13
: Premier jet.
