# Base de Connaissances du Luma

Site web complet pour le partage de connaissances.

## Technique

### Setup

```shell
python3.12 -m venv venv
. venv/bin/activate
```

### Installation & Mise à Jour

```shell
python -m pip install -U pip
python -m pip install -r requirements.txt
```

### Génération du Site

```shell
./build.sh [live]
```

Les fichiers finaux se trouveront dans le dossier "htdocs".

## Crédits

- moteur : [Sphinx](https://www.sphinx-doc.org)
- thème : [Shibuya](https://shibuya.lepture.com)
- police d'écriture : [Monaspace Argon](https://monaspace.githubnext.com)
- logo : [OpenClipart n° 302148](https://openclipart.org/detail/302148) (le favicon est un dérivé de la même image)

Et pour information : [luma](https://fr.wiktionary.org/wiki/luma).
