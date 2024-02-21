# GitHub : Déployer un site web vers Gandi

Gandi permet de déployer un site web via git ou SFTP. Voyons comment automatiser le déploiement via SFTP.

## Prérequis

Nous utiliserons [lftp](https://lftp.yar.ru/lftp-man.html) pour l'envoi des fichiers :

```{literalinclude} snippets/github-deploiement-vers-gandi.sh
    :lines: 3
    :language: shell
```

## Manuel

Les étapes suivantes peuvent servir à déployer depuis n'importe quelle machine et ne sont pas liées à GitHub.

### Constantes

D'abord, nous aurons besoin de définir ces constantes :

```{literalinclude} snippets/github-deploiement-vers-gandi.sh
    :lines: 5-8
    :language: shell
```

### ⚠️ Approuver la Connexion

```{hint}
Bien que nécessaire, cette étape est à ne faire qu'une seule fois par machine.
```

Approuver la connexion au serveur pour éviter l'erreur "*Fatal error: Host key verification failed*" :

```{literalinclude} snippets/github-deploiement-vers-gandi.sh
    :lines: 10-11
    :language: shell
```

### Répliquer

Voici la dernière étape qui permet de faire un miroir d'un dossier local vers un dossier distant (remplacer `FOLDER` par le dossier local) :

```{literalinclude} snippets/github-deploiement-vers-gandi.sh
    :lines: 13-16
    :emphasize-lines: 2
    :language: shell
```

## Automatisation

Maintenant que les étapes sont connues, nous utiliserons un *workflow* GitHub pour déployer le site à chaque changement poussé sur la branche principale du dépôt.

### Secrets

Dans les paramètres du dépôt GitHub, déclarer des secrets identiques aux [constantes](#constantes) déclarées plus haut.

### *Workflow*

Voici le script YAML complet :

```{literalinclude} snippets/github-deploiement-vers-gandi.yml
    :caption: .github/workflows/deploy.yml
    :emphasize-lines: 6,25
    :language: yaml
```

### Exemple Complet

Un exemple spécifique à Python, utilisé par ce site même, peut être visible par ici : [BoboTiG/luma deploy.yml](https://github.com/BoboTiG/luma/blob/main/.github/workflows/deploy.yml).

## 📜 Historique

2024-02-04
: Premier jet.
