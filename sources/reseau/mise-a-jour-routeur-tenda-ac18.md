# Mise à jour du routeur Tenda AC18 (AC1900)

## Liens

- *Firmware* : [2024.3](https://freshtomato.org/downloads/freshtomato-arm/2024/2024.3/freshtomato-TendaAC18-K26ARM-2024.3-AIO-64K.zip) ([MD5](https://freshtomato.org/downloads/freshtomato-arm/2024/2024.3/MD5SUM) = `c06381c8a1b14ebad900144abc8cdd78`) ;
- [CHANGELOG](https://bitbucket.org/pedro311/freshtomato-arm/src/arm-master/CHANGELOG).

## Mise à jour Simple

Pour effectuer une mise à jour simple :

1. Décompresser l’archive pour récupérer le fichier `.trx` ;
2. Dans {menuselection}`Administration --> Upgrade`, sélectionner le fichier `.trx` ;
3. Cliquer sur le bouton "Upgrade" ;
4. Attendre que le routeur redémarre.

## Remise à Zéro

Pour effectuer une mise à jour et repartir sur des bases saines, c’est-à-dire tout supprimer et repartir de zéro :

1. Exporter la configuration depuis {menuselection}`Administration --> Configuration` ;
2. Décompresser l’archive pour récupérer le fichier `.trx` ;
3. Dans {menuselection}`Administration --> Upgrade`, sélectionner le fichier `.trx` et cocher "*After flashing, erase all data in NVRAM memory*" ;
4. Cliquer sur le bouton "Upgrade" ;
5. Quand le redémarrage du routeur est terminé, réimporter la configuration depuis [192.168.1.1](http://192.168.1.1/) (`root:admin`).

---

## 📜 Historique

2024-08-10
: Mise à jour `2024.2` → `2024.3`.

2024-05-31
: Mise à jour `2024.1` → `2024.2`.

2024-03-04
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2020/02/10/14/23/58-tenda-ac18-ac1900).
: Mise à jour `2023.5` → `2024.1`.

2023-12-25
: Mise à jour `2023.4` → `2023.5`.

2023-11-19
: Mise à jour `2020.1` → `2023.4` (il y a eu plusieurs mises à jour intermédiaires, mais je n’ai pas gardé de trace).

2020-02-10
: Premier jet.
