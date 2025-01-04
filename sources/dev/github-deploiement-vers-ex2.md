# GitHub : Déployer un site web vers EX2

[EX2](https://www.ex2.com/clients/aff.php?aff=1020) permet de déployer un site web via git ou FTP. Voyons comment automatiser le déploiement via FTP.

## Prérequis

Nous utiliserons [lftp](https://lftp.yar.ru/lftp-man.html) pour l’envoi des fichiers :

```{literalinclude} snippets/github-deploiement-vers-ex2.sh
:lines: 3
:language: shell
```

Se connecter au cPanel de l’instance sur EX2 pour ajouter un compte FTP. La seule caractéristique à vérifier est que le répertoire sélectionné soit bien le dossier final contenant les fichiers, par exemple `public_html/luma`.

## Manuel

Les étapes suivantes peuvent servir à déployer depuis n’importe quelle machine et ne sont pas liées à GitHub.

### Constantes

D’abord, nous aurons besoin de définir ces constantes :

```{literalinclude} snippets/github-deploiement-vers-ex2.sh
:lines: 5-7
:language: shell
```

### Répliquer

Voici la dernière étape qui permet de faire un miroir d’un dossier local vers un dossier distant (remplacer `FOLDER` par le dossier local) :

```{literalinclude} snippets/github-deploiement-vers-ex2.sh
:lines: 9-12
:emphasize-lines: 2
:language: shell
```

## Automatisation

Maintenant que les étapes sont connues, nous utiliserons un *workflow* GitHub pour déployer le site à chaque changement poussé sur la branche principale du dépôt.

### Secrets

Dans les paramètres du dépôt GitHub, créer des secrets identiques aux [constantes](#constantes) déclarées plus haut.

### *Workflow*

Voici le script YAML complet :

```{literalinclude} snippets/github-deploiement-vers-ex2.yml
:caption: .github/workflows/deploy.yml
:lines: 2-
:emphasize-lines: 6,20
:language: yaml
```

### Exemple Complet

Un exemple spécifique à Python, utilisé par ce site même, peut être visible par ici : [BoboTiG/luma deploy.yml](https://github.com/BoboTiG/luma/blob/main/.github/workflows/deploy.yml).

## 📜 Historique

2025-01-04
: Premier jet.
