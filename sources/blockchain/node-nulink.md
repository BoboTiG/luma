# Comment déployer un nœud NuLink ?

```{figure} images/nulink-logo.svg
 :width: 340
  :height: 96
  :alt: NuLink Logo
  :align: center

  Site web : [www.nulink.org](https://www.nulink.org)
```

Ce guide est une traduction libre et simplifiée de la [documentation officielle](https://docs.nulink.org/products/stakers/nulink_worker/) pour le déploiement d'un nœud NuLink, plus communément appelé *node validator*, *worker node* ou encore *staker node*.

## Configuration Requise

- système d'exploitation : **Debian** GNU/Linux
- architecture : x86-64
- espace disque : 30 Gio NVMe
- mémoire : 4 Gio de RAM
- une adresse IP statique ;
- le port 9951 ouvert.

À savoir, il te faudra 2 comptes :
1. un compte *staker* qui *stake* ses [NLK](https://testnet.bscscan.com/token/0x06a0f0fa38ae42b7b3c8698e987862afa58e90d9), n'importe quel compte Metamask ou Rabby fait l'affaire ;
2. un compte *worker* qui sera lié au compte *staker* (on parle de *bond* en anglais), et nous verrons comment le créer par la suite.

---

## Avant-propos

Les futures commandes à taper dans une console sont précédées par une légende pour indiquer sur quel environnement elles doivent être exécutées.

Exemple avec une commande qui devra être tapée dans la console de ton ordinateur (PC) :

```{code-block} shell
    :caption: 🖥️ Ordinateur (PC)

echo "Coucou depuis l'ordi !"
```

Et une commande qui devra être tapée dans la console du serveur (VPS, pour *Virtual Private Server*) sur lequel le nœud sera déployé :

```{code-block} shell
    :caption: ☁️ Serveur (VPS)

echo 'Coucou depuis le serveur !'
```

```{tip}
Chaque commande peut être copiée/collée directement depuis cet article vers ta console (il y a une icône qui apparait en haut à droite de chaque bloc de code quand la souris passe dessus).
Quand il y a une partie de la commande a modifier manuellement :
- je le préciserai en amont ;
- la légende du bloc de code contiendra l'émoji ✍️ ;
- la/les ligne en question sera surlignée.
```

```{tip}
Afin de vérifier qu'une commande se soit terminée avec succès, tu dois voir que la dernière ligne affichée dans la console, après l'avoir exécutée, devra être "OK".
Si ce n'est pas le cas, il y a eu une erreur.
```

---

## Créer un Compte *Worker*

```{important}
Le compte du *worker* **ne peut pas** être un compte ordinaire Metamask.
```

```{attention}
Le mot de passe que tu créeras pour ce compte doit faire **8 caractères ou plus** ([source](https://github.com/NuLink-network/nulink-core/blob/v0.5.0_d98e1de/nulink/crypto/keystore.py#L228)).
```

Nous devons passer par Geth pour la création du compte.

Donc, sur ton PC, installe Geth :

```{literalinclude} snippets/node-nulink.sh
    :caption: 🖥️ Ordinateur (PC)
    :lines: 3-9
    :language: shell
```

Et créé le compte :

```{literalinclude} snippets/node-nulink.sh
    :caption: 🖥️ Ordinateur (PC)
    :lines: 11-12
    :language: shell
```

```{caution}
Garde bien les informations en sécurité (le mot de passe et le fichier contenant la clef privée).
```

Le fichier de la clef privée se trouve dans le dossier **keystore** et se nomme quelque chose comme **UTC--xxx** (où "xxx" est spécifique à chacun).

---

## Hébergement

Créé ton compte sur Contabo, et utilise [ce lien](https://contabo.com/en/vps/cloud-vps-2/?image=debian.329&qty=1&contract=1&storage-type=vps-2-200-gb-nvme) vers le serveur à louer avec la bonne configuration présélectionnée.
À l'heure où j'écris ces lignes, la première facture est de 18,60 €, puis 11,40 €/mois.

Si tu décides d'utiliser un autre fournisseur, voire un ordinateur local, voici la configuration sélectionnée :

- 6 vCPU Cores
- 16 GB RAM
- 200 GB NVMe
- Debian 12

### Configuration SSH

Quand tu auras pris connaissance de l'adresse IP du serveur, configure l'accès SSH sur ta machine (remplace `ADRESSE_IP` par l'adresse IP du serveur) :

```{literalinclude} snippets/node-nulink.sh
    :caption: 🖥️ Ordinateur (PC) ✍️
    :lines: 85-90
    :language: shell
    :emphasize-lines: 4
```

Maintenant, quand tu devras communiquer avec, ou te connecter, au serveur, tu n'auras qu'à utiliser `nulink` au lieu de saisir l'adresse IP à chaque fois.

````{admonition} Commandes avant/après
    :class: dropdown

Avant :

```{code-block} shell
    :caption: 🖥️ Ordinateur (PC) ✍️

ssh root@ADRESSE_IP
scp root@ADRESSE_IP:PATH/TO/FILE FILE
scp FILE root@ADRESSE_IP:PATH/TO/FILE
```

Dorénavant :

```{code-block} shell
    :caption: 🖥️ Ordinateur (PC)

ssh nulink
scp nulink:PATH/TO/FILE FILE
scp FILE nulink:PATH/TO/FILE
```

````

### Sauvegarde la Clef Privée

Envoie le fichier de la clef privée depuis ton ordinateur vers le serveur :

```{literalinclude} snippets/node-nulink.sh
    :caption: 🖥️ Ordinateur (PC)
    :lines: 14-16
    :language: shell
```

### Connexion

Connecte toi en SSH au serveur (utilise le mot de passe que tu as défini sur Contabo) :

```{code-block} shell
    :caption: 🖥️ Ordinateur (PC)

ssh nulink
```

---

### Installation

#### Mise à Jour

Mets à jour le système d'exploitation, puis redémarre :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 17-20
    :language: shell
```

Patiente quelques secondes et [reconnecte toi](#connexion) au serveur.

#### Pare-feu

Installe le pare-feu :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 22-26
    :language: shell
```

#### Docker

Installe Docker :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 28-35
    :language: shell
```

#### NuLink

Pré-requis pour la prochaine étape :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 37-40
    :language: shell
```

Enfin, installe NuLink :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 42-43
    :language: shell
```

---

### Configuration

```{warning}
Envoie maintenant un peu de tBNB sur le compte du *worker*.
```

Enregistre les mots de passe pour plus tard :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :lines: 45
    :language: shell
```

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :lines: 46
    :language: shell
```

Tu dois te déconnecter pour prendre en compte les changements :

```{code-block} shell
    :caption: ☁️ Serveur (VPS)

exit
```

[Reconnecte toi](#connexion), et teste que les mots de passe sont visibles (tu devrais voir 3 lignes avec les 2 mots de passe et "OK") :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 48-50
    :language: shell
```

Initialise NuLink (remplace `FICHIER_CLEF_PRIVEE` par le nom du fichier contenant la clef privée du compte *worker* ["UTC--xxx"] et `ADRESSE_WORKER` par l'adresse publique du compte *worker*) :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :lines: 52-65
    :language: shell
    :emphasize-lines: 7,12
```

```{caution}
Garde bien les informations en sécurité (les douze mots de la *seed phrase* et le fichier contenant la clef privée).
```

Depuis ton PC, récupère une copie de la clef privée :

```{literalinclude} snippets/node-nulink.sh
    :caption: 🖥️ Ordinateur (PC)
    :lines: 67-69
    :language: shell
```

---

### Exécution

Et c'est parti, démarre le nœud :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 70-78
    :language: shell
```

#### Logs

Pour suivre ce qu'il se passe sur le nœud :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 92
    :language: shell
```

Si tu vois « *Working ~ Keep Ursula Online!* » et/ou « *learn_from_teacher_node stop now RELAX.* », ça veut dire que tout fonctionne nickel. Félicitations !

---

### Mises à Jour

Ceci est à effectuer seulement lors d'une [mise à jour du conteneur](https://hub.docker.com/r/nulink/nulink/tags).

Action à faire dans l'ordre sur le serveur :

1. [mets à jour le système](#mise-a-jour) ;
2. supprime le conteneur actuel, puis installe la dernière version :

```{literalinclude} snippets/node-nulink.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 80-83
    :language: shell
```

1. enfin, relance le [nœud](#execution).

---

## Lier les Comptes

Le site web pour la gestion du staking est [https://dashboard.testnet.nulink.org/staking](https://dashboard.testnet.nulink.org/staking).
Plus bas dans cette page, il y a un bouton « *Bond worker* », clique dessus et renseigne l'adresse du compte *worker*. Et voilà !

---

## 📜 Historique

2024-02-10
: [Simplification](#configuration-ssh) des étapes nécessitant SSH.
: Mise à jour de l'adresse du token NLKTest (`0xa22bfb00be8938c50833bfd2444ec721a9eeacc1` → `0x06a0f0fa38ae42b7b3c8698e987862afa58e90d9`) suite à la migration de la phase 1 aux phases 2 & 3.

2024-01-27
: Premier jet.
