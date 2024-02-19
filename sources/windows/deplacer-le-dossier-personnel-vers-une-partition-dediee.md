# Windows : Déplacer le dossier personnel vers une partition dédiée

## Le Script

Pour un gain de place ou pour séparer les données utilisateur du système d'exploitation, ce script batch peut être utile.

Voici ce qu'il fait :

- Création des nouveaux dossiers dans la partition de données ;
- **Déplacement** des données personnelles depuis les anciens dossiers vers les nouveaux ;
- Changement des chemins dans la base de registre ;
- Suppression des anciens dossiers.

Pensez à adapter la partition à la ligne spécifiant `set new_folder=…` (ici `D:`).

```{literalinclude} snippets/deplacer-le-dossier-personnel-vers-une-partition-dediee.bat
    :caption: move-current-user-folder.bat
    :emphasize-lines: 4
    :language: batch
```

## Utilisation

Pour l'utiliser :

- Copiez-le à la racine de la nouvelle partition ;
- Double-cliquez & patientez ;
- Redémarrez l'ordinateur.

## Testé et Approuvé

- Windows Vista
- Windows 7
- Windows 8
- Windows 8.1
- Windows 10

```{todo}
Windows 11
```

---

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2015/03/06/10/49/14-deplacer-le-dossier-personnel-vers-une-partition-dediee).

2015-03-06
: Premier jet.
