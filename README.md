# Base de Connaissances du [Luma](https://fr.wiktionary.org/wiki/luma)

![Logo](sources/_static/logo.svg)

Site web complet pour le partage de connaissances.

## Qualité

La qualité, et la fiabilité des morceaux de code, sont garanties grâce à plusieurs outils spécialisés, et ça se passe dans le fichier [checks.sh](checks.sh).

Les fautes de frappe et de grammaire sont corrigées en temps réel grâce à [LanguageTool](https://languagetool.org). Pour ce faire, installer l’extension VS Code `davidlday.languagetool-linter` et démarrer ce conteneur :

```shell
docker run -p 8081:8010 silviof/docker-languagetool
```

Toutes les contributions sont bienvenues.

## Technique

### Prérequis

```shell
python3.12 -m venv venv
. venv/bin/activate
```

### Installation & Mise à Jour

```shell
python -m pip install -U pip
python -m pip install -r requirements-tests.txt
```

### Génération du Site

```shell
./build.sh [--live]
```

Les fichiers finaux se trouveront dans le dossier [luma](./luma).

## Déploiement

Le déploiement est 100% automatisé.

[![Deploy](https://github.com/BoboTiG/luma/actions/workflows/deploy.yml/badge.svg)](https://github.com/BoboTiG/luma/actions/workflows/deploy.yml)

## Crédits

- moteur : [Sphinx](https://www.sphinx-doc.org)
- thème : [Shibuya](https://shibuya.lepture.com)
- police d’écriture : [Monaspace Argon](https://monaspace.githubnext.com)
- logo : [OpenClipart n° 302148](https://openclipart.org/detail/302148) (le favicon est un dérivé de la même image)
