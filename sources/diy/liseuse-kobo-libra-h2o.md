# La liseuse Kobo Libra H2O

```{figure} images/kobo-libra-h2o.jpg
:alt: Dusk Logo
:align: center

La liseuse Kobo Libra H2O, en mode nuit, affichant "<u>Seconde Fondation</u>", d'Isaac Asimov.
```

Ayant fait l’acquisition de cette liseuse, il fallait passer par quelques étapes avant de pouvoir réellement m’en servir.
Voici une petite liste des choses à faire.

Pour la suite de l’article, la Kobo est vue par le système (GNU/Linux) en tant que */dev/sdc* et ces variables d’environnement sont définies suivant l’emplacement du dossier dans lequel elle est montée :

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 3-7
:emphasize-lines: 1
:language: shell
```

---

## 🚀 Premier Démarrage

Quelques étapes que j’ai préféré faire, mais dont aucune n’est indispensable.

### 💿 Sauvegarde

1. Brancher le cordon USB à l’ordinateur.
2. Lorsque la liseuse démarre, choisir "Vous n’avez pas de réseau Wi-Fi ?".
3. La liseuse est détectée et montée, la démonter.
4. Faire la sauvegarde :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 9-11
   :emphasize-lines: 2
   :language: shell
   ```

5. Remonter la liseuse.
6. Faire une copie du dossier **.kobo**:

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 12
   :language: shell
   ```

### 🔓 Compte Kobo/Rakuten

Outrepasser la demande d’enregistrement pour jouir de la liseuse sans avoir à créer de compte en ligne :

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 13-14
:language: shell
```

### ♻️ Purge Initiale

Supprimer le contenu inclus par défaut :

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 15-16
:language: shell
```

### ™️ Logo

Virer le logo du revendeur :

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 17
:language: shell
```

---

## ⚙️ Mettre à Jour le Firmware

Voici la procédure pour mettre à jour le firmware de la Kobo.

1. Télécharger et installer le firmware :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 19-22
   :language: shell
   ```

2. Éjecter la liseuse et patienter.

---

## 🎛️ Hacker le Firmware

Il y a possibilité de personnaliser quelques [options et comportements](https://www.mobileread.com/forums/forumdisplay.php?f=247) de la liseuse.

1. Suivre l’[étape précédente](mettre-a-jour-le-firmware) en entier et conserver les fichiers pour la suite.
2. Télécharger le patcheur et copier le firmware :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 23-25
   :language: shell
   ```

3. Éditer les fichiers **src/*.yaml** pour activer les patches désirés. Ou éditez le fichier **kobopatch.yaml**. Voici mes options :

   ```{literalinclude} snippets/kobopatch.yaml.orig
   :caption: Fichier : kobopatch.yaml
   :language: yaml
   ```
  
   Modifications apportées à **src/libnickel.so.1.0.0.yaml** :

   ```{literalinclude} snippets/libnickel.so.1.0.0.diff
   :language: diff
   ```

   Afin d'appliquer ces modification à votre fichier, copier le code précédant dans le fichier **libnickel.so.1.0.0.diff**, puis :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 50
   :language: shell
   ```

4. Patcher et installer le firmware modifié :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 26-28
   :language: shell
   ```

5. Éjecter la liseuse. C’est terminé.

---

## 🍽️ NickelMenu

En option, vous pouvez installer un menu supplémentaire, [NickelMenu](https://pgaskin.net/NickelMenu/), qui permet d’ajouter des actions spécifiques intéressantes. Le menu se trouvera en bas à droite de l’écran.
Je m’en sers notamment pour (dés)activer les captures d’écran, inverser les couleurs, enregistrer les logs ou encore démarrer une application de prise de notes/dessins assez cool (voici la liste des [options disponibles](https://github.com/pgaskin/NickelMenu/blob/v0.5.4/res/doc)).

1. Télécharger le fichier et copier le firmware :

   ```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
   :lines: 30-32
   :language: shell
   ```

2. Éjecter la liseuse et patienter.
3. Rebrancher la liseuse.
4. Créer, ou modifier, le fichier de configuration. Voici le contenu du mien :

   ```{literalinclude} snippets/nickel-menu.config
   :caption: Fichier : ${KOBO_ROOT}/.adds/nm/config
   :language: shell

   ```

5. Éjecter la liseuse. C’est terminé.

---

## 📘 Dictionnaire

Installons le dictionnaire [basé sur le Wiktionnaire](https://www.tiger-222.fr/?d=2020/04/17/22/14/21-un-dictionnaire-alternatif-et-complet-pour-la-votre-liseuse):

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 34-37
:language: shell
```

```{tip}
D’autres langues sont disponibles dans le dépôt officiel : [BoboTiG/ebook-reader-dict](https://github.com/BoboTiG/ebook-reader-dict).
```

---

## 🔤 Police de caractères

Un police de caractères supportant un grand nombre de langues est préférable pour l’affichage des étymologies. FreeSerif en est une, du projet [FreeFont](https://www.gnu.org/software/freefont/) :

```{literalinclude} snippets/liseuse-kobo-libra-h2o.sh
:lines: 39-48
:language: shell
```

````{admonition} Aperçu avec le mot "fez"   
:class: dropdown

```{figure} images/dict-fez.png
:alt: Wiktionnaire - fez
:align: center
```
````

````{admonition} Aperçu avec le mot "Zeus"   
:class: dropdown

```{figure} images/dict-zeus.png
:alt: Wiktionnaire - Zeus
:align: center
```
````

---

## 🎣 Sources

- Un grand merci à [BoboTraX](http://www.bobotrax.fr) pour le coup de main.
- [Kobo Firmware Downloads](https://pgaskin.net/KoboStuff/kobofirmware.html).
- [Kobo Firmware Releases](https://wiki.mobileread.com/wiki/Kobo_Firmware_Releases#Mark_7).
- [Kobo Reader - MobileRead Forums](https://www.mobileread.com/forums/forumdisplay.php?s=d5e0bc4615a00d5065ab7258b883f68c&f=223).

---

## 📜 Historique

2024-10-17
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2020/04/04/13/17/31-la-liseuse-kobo-libra-h2o).
: Adaptation du nom du domaine pour le téléchargement du firmware (*kbdownload1-a.akamaihd.net* → *ereaderfiles.kobo.com*).

2023-07-06
: Mise à jour du firmware (`4.34.20097` → `4.37.21582`) et des patches (`v79` → `v82`).

2022-11-10
: Ajout de la section [NickelMenu](#nickelmenu).

2022-10-19
: Mise à jour du firmware (`4.33.19759` → `4.34.20097`) et des patches (`v78` → `v79`).

2022-07-22
: Mise à jour du firmware (`4.31.19086` → `4.33.19759`) et des patches (`v74` → `v78`).
: Ajout de la command `sync` à la fin de chaque étape de copie vers la carte SD.

2022-04-10
: Mise à jour du firmware (`4.30.18838` → `4.31.19086`) et des patches (`v73` → `v74`).
: Correction du lien de téléchargement du [dictionnaire](#dictionnaire).
: Utilisation des variables d’environnement `${KOBO_VERSION}` et `${KOBO_PATCH_VERSION}` pour faciliter les mises à jour.

2021-11-12
: Mise à jour du firmware (`4.26.16704` → `4.30.18838`) et des patches (`v70` → `v73`).

2021-03-08
: Relecture et revue du code.
: Utilisation des variables d’environnement `${KOBO_ROOT}` et `${KOBO_DIR}` pour faciliter les manipulations et améliorer la lisibilité.

2021-03-07
: Mise à jour du firmware (`4.25.15875` → `4.26.16704`) et des patches (`v69` → `v70`).
: Ajout de la commande pour [supprimer le contenu inclus par défaut](#purge-initiale).

2020-11-15
: Mise à jour du firmware (`4.20.14622` → `4.25.15875`) et des patches (`v59` → `v69`).
: Adaptation de l’emplacement du dictionnaire (*.kobo/dict/* → *.kobo/custom-dict/*).
: Ajout de la section [police de caractères](#police-de-caracteres).
