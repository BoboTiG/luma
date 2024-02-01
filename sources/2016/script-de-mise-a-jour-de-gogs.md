# Script de mise à jour de Gogs

Voici un script qui permet de mettre à jour [Gogs](https://gogs.io), un serveur Git parfait à installer chez soi, en l'occurrence sur un Raspberry Pi 2.

```{literalinclude} snippets/script-de-mise-a-jour-de-gogs.sh
    :caption: update-gogs.sh
    :lines: 1-38
    :language: shell
```

Rendre le script exécutable :

```{literalinclude} snippets/script-de-mise-a-jour-de-gogs.sh
    :lines: 41
    :language: shell
```

À utiliser tel que :

```{literalinclude} snippets/script-de-mise-a-jour-de-gogs.sh
    :lines: 42
    :language: shell
```

---

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2016/03/31/15/25/19-script-de-mise-a-jour-de-gogs).

2023-02-25
: Téléchargement de l'archive ZIP depuis [GitHub](https://github.com/gogs/gogs/releases) au lieu de [dl.gogs.io](https://dl.gogs.io/).

2021-04-10
: Support de Gogs 0.12.0+.

2018-08-17
: Correction de `[ -n $EUID ]` → `[ $EUID -eq 0 ]`.
: Correction de la variable `today` qui ajoutait un "M" à la fin.
: Utilisation de `bash` au lieu de `sh`.

2018-04-28
: Support de Gogs 0.11.43+.

2017-04-08
: Revue des liens et meilleure qualité du script.

2016-04-16
: Utilisation des chemins absolus des exécutables.

2016-03-31
: Premier jet.
