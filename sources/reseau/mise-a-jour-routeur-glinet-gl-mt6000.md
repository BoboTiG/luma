# Mise à jour du routeur GL.iNet GL-MT6000

<!-- pyml disable link-fragments -->
## Liens

- [La fiche du routeur sur OpenWrt](https://openwrt.org/toh/gl.inet/gl-mt6000) ;

## Première Installation

Le routeur contient déjà une version modifiée d’OpenWrt, nous allons pouvoir faire une installation d’OpenWrt officielle :

1. Télécharger la dernière image *sysupgrade* **non-SNAPSHOT** (pour l’exemple, je prends la version du moment : `23.05.5`) : [openwrt-23.05.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin](https://downloads.openwrt.org/releases/23.05.5/targets/mediatek/filogic/openwrt-23.05.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin) depuis [https://downloads.openwrt.org/releases](https://downloads.openwrt.org/releases) ;
1. Rendez-vous sur l’interface du routeur à l’adresse [192.168.8.1](http://192.168.8.1/) ;
1. Dans {menuselection}`SYSTEM --> Upgrade --> Local Upgrade`, sélectionner le fichier `.bin` et **décocher** "*Keep Settings*" ;
1. Cliquer sur le bouton "Upgrade" ;
1. Attendre que le routeur redémarre ;
1. Rendez-vous sur la nouvelle interface du routeur à l’adresse [192.168.1.1](http://192.168.1.1/) (`root:root`).

## Mise à Jour

```{note}
Vérifier dans les [informations de version](https://openwrt.org/releases/start) que la mise à jour entre deux versions est possible. Sinon, faire une [première installation](premiere-installation), ou installer par palier de versions intermédiaires (par exemple : `23.05.5` → `24.10.5` → `25.12.0`).
```

1. Télécharger la nouvelle image *sysupgrade* **non-SNAPSHOT** (pour l’exemple, je prends la version du moment : `24.10.5`) : [openwrt-24.10.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin](https://mirror-03.infra.openwrt.org/releases/24.10.5/targets/mediatek/filogic/openwrt-24.10.5-mediatek-filogic-glinet_gl-mt6000-squashfs-sysupgrade.bin) depuis [https://downloads.openwrt.org/releases](https://downloads.openwrt.org/releases) ;
1. Rendez-vous sur l’interface du routeur à l’adresse [192.168.8.1](http://192.168.8.1/) ;
1. Dans {menuselection}`SYSTEM --> Upgrade --> Local Upgrade`, sélectionner le fichier `.bin` et **cocher** "*Keep Settings*" ;
1. Cliquer sur le bouton "Upgrade" ;
1. Attendre que le routeur redémarre ;
1. Rendez-vous sur l’interface du routeur à l’adresse [192.168.1.1](http://192.168.1.1/).

## 📜 Historique

2025-12-23
: Complétion de la partie [mise à jour](#mise-a-jour).

2024-12-16
: Premier jet.
