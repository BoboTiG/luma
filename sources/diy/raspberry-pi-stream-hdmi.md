# Raspberry Pi : stream → HDMI

L'idée est la suivante : **afficher le flux vidéo d'une caméra IP sur un écran**.
Pour ce faire, nous utiliserons un **Raspberry Pi** (abrégé Rpi par la suite) qui fera la transition entre le flux (*stream*) de la caméra vers l'écran, via la sortie **HDMI**.

## Le Flux Vidéo

Première étape, la plus hasardeuse et plus ou moins complexe : récupérer l'adresse du flux vidéo. Cet article ne décrira pas comment le faire puisque la méthode changera suivant la marque de la caméra, voire même suivant le modèle au sein d'une même marque.

Format d'adresse du flux vidéo :

```{code-block} text
http://IP/live/0/mjpeg.jpg
```

````{note}
Si l'accès au flux est sécurisé par une authentification simple à l'aide d'un nom d'utilisateur et d'un mot de passe, l'adresse complète du flux vidéo sera plutôt de ce genre :

```{code-block} text
http://USER:PASSWORD@IP/live/0/mjpeg.jpg
```
````

---

## Mise en Place

Une [Raspbian minimale](https://www.tiger-222.fr/?d=2016/01/04/17/25/32-raspbian-installation-minimale) fera l'affaire sur votre Rpi. Nous allons installer [OMXPlayer](https://github.com/popcornmix/omxplayer), un lecteur vidéo spécialement conçu pour le processeur graphique (GPU) du Rpi :

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :lines: 26
    :language: shell
```

Ensuite, voici la ligne de commande pour lire le flux vidéo vers la sortie HDMI :

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :lines: 28
    :language: shell
```

---

## Script Complet

Ci-dessous est le script complet qui lancera automatiquement l'affichage de la caméra sur l'écran :

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :caption: /opt/stream-hdmi.sh
    :lines: 1-24
    :language: shell
```

```{note}
- `sleep 10`{l=shell} est important, sans ça, OMXPlayer s'arrête sur une erreur « *Aborted* » ;
- `--aidx`{l=shell} permet de choisir la piste audio (**-1** pour désactiver l'audio) ;
- l'utilité du `while true`{l=shell} est de relancer OMXPlayer en cas de rupture du flux vidéo de la part de la caméra.
```

---

## Exemple

### D-Link DCS-2210

Un exemple concret avec la caméra de surveillance [D-Link DCS-2210](http://www.dlink.com/fr/fr/support/product/dcs-2210-full-hd-poe-day-night-camera) :

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :lines: 30-33
    :language: shell
```

Le flux choisi est le profile n°2, configuré comme tel :

- *Mode* : JPEG (car le Raspberry Pi 1 n'est pas assez puissant pour décoder du MPEG4/H264 en haute qualité) ;
- *Frame size* : 1280x720 ;
- *View window area* : 1280x720 ;
- *Maximum frame rate* : 25 (ou 30 suivant le modèle) ;
- *Video quality* : Excellent.

---

## Lancement au Démarrage

Plusieurs solutions s'offrent à nous :

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :caption: ~/.profile
    :lines: 35-36
    :language: shell
```

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :caption: /etc/cron.d/stream-hdmi
    :lines: 38
    :language: shell
```

```{literalinclude} snippets/raspberry-pi-stream-hdmi.sh
    :caption: /etc/rc.local
    :lines: 40-42
    :language: shell
```

---

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2016/03/31/15/25/19-script-de-mise-a-jour-de-gogs).

2016-11-19
: Suppression de l'argument `--loop` (convient pour les fichiers, pas les flux).
: Ajout de l'exemple [D-Link DCS-2210](#d-link-dcs-2210).

2016-06-23
: Utilisation de l'argument `--aidx`.

2016-06-02
: Premier jet.
