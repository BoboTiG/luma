# [testnet] Comment déployer un nœud Dusk ?

```{figure} images/dusk-logo.svg
 :width: 96
  :height: 96
  :alt: Dusk Logo
  :align: center

  Site web : [dusk.network](https://dusk.network)
```

```{note}
Ce document est valide du 15 février 2024 au 15 mars 2024.
```

Ce guide est une traduction libre et légèrement modifiée de la [documentation officielle](https://docs.dusk.network/itn/node-running-guide) pour le déploiement d'un nœud Dusk, plus communément appelé *node provisioner*.

## [Configuration Requise](https://docs.dusk.network/getting-started/node-setup/node-requirements#provisioner-specifications)

- système d'exploitation : **Debian** GNU/Linux
- architecture : x86-64
- espace disque : 50 Gio NVMe
- mémoire : 4 Gio de RAM

---

## Avant-propos

```{include} _node-avant-propos.md
```

---

## Créer un Compte

Rendez-vous sur le [wallet Dusk](https://wallet.dusk.network) pour créer un compte.

```{caution}
Bien garder les 12 mots de la *seed phrase* quelque part en sécurité.
```

---

## Hébergement

Créé un compte sur Contabo, et utiliser [ce lien](https://contabo.com/en/vps/cloud-vps-2/?image=debian.329&qty=1&contract=1&storage-type=vps-2-200-gb-nvme) vers le serveur à louer avec la bonne configuration présélectionnée.
À l'heure où j'écris ces lignes, la première facture est de 18,60 €, puis 11,40 €/mois.

Vérifier la configuration sélectionnée :

- 6 vCPU Cores
- 16 GB RAM
- 200 GB NVMe
- Debian 12

### Configuration SSH

Lorsque le serveur sera opérationnel et que son adresse IP sera connue, configurons l'accès SSH sur le PC (remplacer `ADRESSE_IP` par l'adresse IP du serveur) :

```{literalinclude} snippets/node-dusk.sh
    :caption: 🖥️ Ordinateur (PC) ✍️
    :lines: 3-8
    :language: shell
    :emphasize-lines: 4
```

### Connexion

Se connecter en SSH au serveur (utiliser le mot de passe que défini sur Contabo) :

```{code-block} shell
    :caption: 🖥️ Ordinateur (PC)

ssh dusk
```

---

## Installation

### Mise à Jour

Mettre à jour le système d'exploitation, puis redémarrer :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 10-13
    :language: shell
```

Patienter quelques secondes et se [reconnecter](#connexion) au serveur.

### Pare-feu

Installer et configurer le pare-feu pour autoriser **seulement** les connexions entrantes sur les ports SSH et du nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 15-20
    :language: shell
```

### Serveur NTP

```{include} _node-ntp.md
```

### Dusk

Télécharger et exécuter le script d'installation automatique pour Dusk :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 22-24
    :language: shell
```

---

## Configuration

### Mot de Passe

Stocker le mot de passe du *wallet* Dusk afin de ne plus avoir à la taper pour toutes les futures commandes `rusk-wallet …` ([source](https://github.com/dusk-network/wallet-cli/blob/v0.21.0/src/bin/README.md#headless-mode)) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :emphasize-lines: 1
    :lines: 55-56
    :language: shell
```

Se [reconnecter](#connexion), et tester que le mot de passe est visible (il devrait s'afficher, suivi de "OK") :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 58-59
    :language: shell
```

### Importer le Compte

```{attention}
Les 12 mots de la *seed phrase* doivent être entrés en **minuscule**, chacun **séparé par un espace**.
```

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 26
    :language: shell
```

### Exporter les Clefs de Consensus

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 28-29
    :language: shell
```

---

## Exécution

Et c'est parti, démarrons le nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 32
    :language: shell
```

### Logs

Pour suivre la synchronisation du nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 34
    :language: shell
```

### Synchronisation

Cette commande renvoie le dernier bloc de la blockchain :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 65
    :language: shell
```

Et celle-ci renvoie le dernier bloc synchronisé par le nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 61-63
    :language: shell
```

Quand les deux blocs sont identiques, cela voudra dire que le nœud est synchronisé.

---

## Staking

```{attention}
Lors du premier lancement, ne commencer à *staker* des *tokens* que lorsque le nœud approche la fin de sa [synchronisation](#synchronisation) (quand il reste moins de 4 320 blocs à récupérer).
```

C'est la dernière étape pour pouvoir créer des blocs et participer au réseau.

### Balance

Afin de savoir combien il y a de *tokens* sur le *wallet* :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 36
    :language: shell
```

### *Stake*

Pour l'exemple, plaçons 1 000 tDUSK en *staking* (c'est le minimum requis, lien vers le [fausset](https://docs.dusk.network/itn/testnet-faucet/)) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 37
    :language: shell
```

````{admonition} Exemple de sortie
    :class: toggle

```{code-block}
✔ Please enter wallet password: · [hidden]
2024-02-16T06:42:38.853692Z  INFO rusk_wallet::io::status: status="Opening notes database"
2024-02-16T06:42:39.410372Z  INFO rusk_wallet::io::status: status="Getting cached note position..."
2024-02-16T06:42:39.410540Z  INFO rusk_wallet::io::status: status="Fetching fresh notes..."
2024-02-16T06:42:39.486784Z  INFO rusk_wallet::io::status: status="Connection established..."
2024-02-16T06:42:39.490624Z  INFO rusk_wallet::io::status: status="Streaming notes..."
2024-02-16T06:42:40.226524Z  INFO rusk_wallet::io::status: status="Fetching stake..."
2024-02-16T06:42:40.294510Z  INFO rusk_wallet::io::status: status="Stake received!"
Staking address: [REDACTED]
2024-02-16T06:42:40.298475Z  INFO rusk_wallet::io::status: status="Requesting stct proof..."
2024-02-16T06:42:45.970020Z  INFO rusk_wallet::io::status: status="Stct proof success!"
2024-02-16T06:42:45.974639Z  INFO rusk_wallet::io::status: status="Fetching opening notes..."
2024-02-16T06:42:47.099239Z  INFO rusk_wallet::io::status: status="Opening notes received!"
2024-02-16T06:42:47.099421Z  INFO rusk_wallet::io::status: status="Fetching anchor..."
2024-02-16T06:42:47.204651Z  INFO rusk_wallet::io::status: status="Anchor received!"
2024-02-16T06:42:47.227090Z  INFO rusk_wallet::io::status: status="Proving tx, please wait..."
2024-02-16T06:43:08.214350Z  INFO rusk_wallet::io::status: status="Proof success!"
2024-02-16T06:43:08.219467Z  INFO rusk_wallet::io::status: status="Attempt to preverify tx..."
2024-02-16T06:43:08.427675Z  INFO rusk_wallet::io::status: status="Preverify success!"
2024-02-16T06:43:08.427721Z  INFO rusk_wallet::io::status: status="Propagating tx..."
2024-02-16T06:43:08.527562Z  INFO rusk_wallet::io::status: status="Transaction propagated!"
2024-02-16T06:43:08.597338Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (1/30)"
2024-02-16T06:43:09.685356Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (2/30)"
2024-02-16T06:43:10.810684Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (3/30)"
2024-02-16T06:43:11.896795Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (4/30)"
2024-02-16T06:43:13.002293Z  INFO rusk_wallet::io::status: status="Waiting for confirmation... (5/30)"
[TRANSACTION HASH REDACTED]
```
````

````{hint}
La commande précédente **ne peut pas** être utilisée à plusieurs reprises pour augmenter le nombre de *tokens* à *staker*.

Voici la procédure pour *staker* plus de *tokens* (remplacer `AMOUNT` par le nombre de *tokens*) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :lines: 67-68
    :emphasize-lines: 2
    :language: shell
```
````

### Vérification

Pour vérifier le nombre de *tokens* en *staking* (peut être aussi vérifié via le *wallet* Dusk) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 38
    :language: shell
```

Et pour connaître le montant des récompenses accumulées :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 39
    :language: shell
```

---

## Participation

Enfin, lorsque le nœud est à jour, que les *tokens* sont en *staking* et qu'au minimum 2 époques sont passées (ou 4 320 blocs), cette commande permet de voir quand le nœud est sélectionné pour créer un bloc :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 42
    :language: shell
```

```{astuce}
Plus il y a de *tokens* en *staking*, plus il y a de chances d'être sélectionné.
```

### *Slashing*

Le *slashing* est un système de protection qui pénalise les mauvais comportements. Lorsque ça [arrive](https://github.com/dusk-network/rusk/issues/1415) au nœud, une partie des récompenses est perdue, et s'il n'y en a pas, alors la participation au réseau est stoppée jusqu'à l'époque suivante.

#### Raisons

Dans l'immédiat, la seule raison connue est quand un pair trouve que le nœud a mis trop de temps pour valider un bloc. Il n'y a rien à faire pour éviter ça, juste espérer qu'avoir un [serveur NTP](#serveur-ntp) performant aide à prévenir cela.

---

## Débogage

Section pour les cas où le système ne fonctionne pas comme prévu.

### *Block Mode Error*

Le mot de passe entré pour la commande `rusk-wallet …` est incorrect.

### Repartir de Zéro

Si nécessaire, repartir de zéro :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 45-50
    :language: shell
```

### Règles du Pare-feu

Liste des règles actives :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 53
    :language: shell
```

Voici la sortie attendue :

```{code-block}
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     LIMIT IN    Anywhere
8080/tcp                   ALLOW IN    Anywhere
9000/udp                   ALLOW IN    Anywhere
9000:9005/udp              ALLOW IN    Anywhere
22/tcp (v6)                LIMIT IN    Anywhere (v6)
8080/tcp (v6)              ALLOW IN    Anywhere (v6)
9000/udp (v6)              ALLOW IN    Anywhere (v6)
9000:9005/udp (v6)         ALLOW IN    Anywhere (v6)
```

Liste des ports réellement ouverts :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 52
    :language: shell
```

````{admonition} Exemple de sortie
    :class: toggle

```{code-block}
    :emphasize-lines: 8-9

COMMAND   PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd      530    root    3u  IPv4   2288      0t0  TCP *:22 (LISTEN)
sshd      530    root    4u  IPv6   2290      0t0  TCP *:22 (LISTEN)
chronyd 37323 _chrony    5u  IPv4 264489      0t0  UDP 127.0.0.1:323
chronyd 37323 _chrony    6u  IPv6 264490      0t0  UDP [::1]:323
rusk    38995    dusk   23u  IPv4 269825      0t0  UDP *:46317
rusk    38995    dusk   24u  IPv6 269826      0t0  UDP *:41981
rusk    38995    dusk   25u  IPv4 269827      0t0  UDP ADRESSE_IP:9000
rusk    38995    dusk   27u  IPv4 269831      0t0  TCP 127.0.0.1:8080 (LISTEN)
```
````

---

## 🔗 Liens Utiles

- [Statistiques (API)](https://api.dusk.network/v1/stats)
- [Statistiques avec carte des nœuds](https://explorer.dusk.network/charts)

## 📜 Historique

2024-02-22
: Mise à jour de la version du script d'installation de Dusk (`0.1.2` → `0.1.3`).
: Mise à jour de la version du script d'installation de Dusk (`0.1.3` → `0.1.4`).

2024-02-21
: Mise à jour de la version du script d'installation de Dusk (`0.1.1` → `0.1.2`).

2024-02-19
: Mise à jour de la version du script d'installation de Dusk (`0.1.0` → `0.1.1`).

2024-02-17
: Règle SSH du pare-feu plus protectrice.

2024-02-16
: Premier jet.
