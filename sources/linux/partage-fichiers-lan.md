# Partager simplement ses fichiers en LAN

L'idée est simple : démarrer un serveur de fichiers local.

Rendez-vous dans le dossier contenant les fichiers à partager et exécutez une des commandes suivantes :

`````{tabs}

````{tab} Python
```{code-block} shell
python -m http.server 8080 [-d FOLDER]
```
````

````{tab} PHP
```{code-block} shell
# apt install php-cli
php -S 0.0.0.0:8080 [-t FOLDER]
```
````

`````

---

## 📜 Historique

2024-02-13
: Suppression du code Python 2.

2024-02-07
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2018/12/18/10/01/39-partager-simplement-ses-fichiers-en-lan).

2019-02-23
: Remplacement de `localhost` par `0.0.0.0` pour PHP.
: Utilisation du port `8080` à la place de `5555`.

2018-12-18
: Premier jet.
