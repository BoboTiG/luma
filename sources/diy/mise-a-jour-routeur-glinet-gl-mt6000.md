# Mise à jour du routeur GL.iNet GL-MT6000

## Liens

- [La fiche du routeur sur OpenWrt](https://openwrt.org/toh/gl.inet/gl-mt6000) ;

## Première Installation

Le routeur contient déjà une version modifiée d'OpenWrt, nous allons pouvoir faire une installation d'OpenWrt officielle :

1. Télécharger la dernière image *sysupgrade* **non-SNAPSHOT** : [openwrt-23.05.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin](https://downloads.openwrt.org/releases/23.05.5/targets/mediatek/filogic/openwrt-23.05.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin) ;
1. Rendez-vous sur l'interface du routeur à l'adresse [192.168.8.1](http://192.168.8.1/) ;
1. Dans {menuselection}`SYSTEM --> Upgrade --> Local Upgrade`, sélectionner le fichier `.bin` et **décocher** "*Keep Settings*" ;
1. Cliquer sur le bouton "Upgrade" ;
1. Attendre que le routeur redémarre ;
1. Rendez-vous sur la nouvelle interface du routeur à l'adresse [192.168.1.1](http://192.168.1.1/) (`root:root`).

## Mise à Jour

TBD lors de la première fois.

---

## 📜 Historique

2024-12-16
: Premier jet.
