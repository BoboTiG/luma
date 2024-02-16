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

### Installation

#### Mise à Jour

Mettre à jour le système d'exploitation, puis redémarrer :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 10-13
    :language: shell
```

Patienter quelques secondes et se [reconnecter](#connexion) au serveur.

#### Pare-feu

Installer et configurer le pare-feu pour autoriser **seulement** les connexions entrantes sur les ports SSH et du nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 15-20
    :language: shell
```

#### Dusk

Télécharger et exécuter le script d'installation automatique pour Dusk :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 22-23
    :language: shell
```

---

### Configuration

#### Importer le Compte

```{attention}
Les 12 mots de la *seed phrase* doivent être entrés en **minusule**, chacun **séparé par un espace**.
```

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 25
    :language: shell
```

#### Exporter la Clef de Consensus

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 27
    :language: shell
```

Puis stocker le mot de passe de la clef de consensus :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 29
    :language: shell
```

---

### Exécution

Et c'est parti, démarrons le nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 31
    :language: shell
```

#### Logs

Pour suivre la synchronisation du nœud :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 33
    :language: shell
```

En relançant la commande plusieurs fois d'affilée, on devrait voir que `height` augmente. À la fin, il devra avoir la même valeur que celle de [l'explorateur de blocs](https://explorer.dusk.network).

````{admonition} Exemple de ligne de log (height vaut 240)
    :class: toggle

```{code-block}
2024-02-16T06:19:48.992610Z  INFO node::chain::acceptor: event="block accepted" height=240 iter=0 hash="2e9a03c5472e7813...c456b476b266c62f" txs=0 state_hash="f67d16bde7a6c1bb...1a4dc2788b2b5138" fsv_bitset=32924659 ssv_bitset=16412031 block_time=3 generator="xEXp8qBarpXnVD9D" dur_ms=7 label="Final" ffr=false
```
````

---

### Staking

C'est la dernière étape pour pouvoir créer des blocs et participer au réseau.

#### Balance

Afin de savoir combien il y a de *tokens* sur le *wallet* :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 35
    :language: shell
```

#### *Stake*

Pour l'exemple, plaçons 1 000 tDUSK en *stake* (c'est le minimum) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 36
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

```{hint}
La commande précédente peut être utilisée à plusieurs reprises pour augmenter le nombre de *tokens* à *staker*.
```

#### Vérification

Pour vérifier le nombre de *tokens* en *staking* (peut être aussi vérifié via le *wallet* Dusk) :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 37
    :language: shell
```

### Participation

Enfin, lorsque le nœud est à jour, que les *tokens* sont en *staking* et qu'au minimum 2 époques sont passées (ou 4 320 blocs), cette commande permet de voir quand le nœud est sélectionné pour créer un bloc :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 39
    :language: shell
```

La commande ci-dessous permet de voir tous les blocs créés :

```{literalinclude} snippets/node-dusk.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 40
    :language: shell
```

```{astuce}
Plus il y a de *tokens* en *staking*, plus il y a de chances d'être sélectionné.
```

---

## 🔗 Liens Utiles

- [Statistiques (API)](https://api.dusk.network/v1/stats)
- [Statistiques avec carte des nœuds](https://explorer.dusk.network/charts)

## 📜 Historique

2024-02-16
: Premier jet.