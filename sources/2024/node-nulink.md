# Comment déployer un nœud NuLink ?


```{figure} /images/nulink-logo-light.svg
  :width: 340
  :height: 96
  :alt: NuLink Logo
  :class: light-only
  :align: center

  Site web : [www.nulink.org](https://www.nulink.org)
```
```{figure} /images/nulink-logo-dark.svg
  :width: 340
  :height: 96
  :alt: NuLink Logo
  :class: dark-only
  :align: center

  Site web : [www.nulink.org](https://www.nulink.org)
```

Ce guide est une traduction libre et simplifiée de la documentation officielle pour le déploiement d'un nœud NuLink, plus communément appelé *node validator*, *worker node* ou encore *staker node*.

Configuration minimale requise :

- sytème d'exploitation : **Debian** GNU/Linux
- architecture : x86-64
- espace disque : 30 Gio NVMe
- mémoire : 4 Gio de RAM
- une addresse IP statique ;
- le port 9951 ouvert.

À savoir, il te faudra 2 comptes :
1. un compte *staker* qui *stake* ses [NLK](https://testnet.bscscan.com/token/0xa22bfb00be8938c50833bfd2444ec721a9eeacc1), n'importe quel compte Metamask ou Rabby fait l'affaire ;
2. un compte *worker* qui sera lié au compte *staker* (on parle de *bond* en anglais), et nous allons voir tout de suite comment le générer.

---

## Avant-Propos

Les futures commandes à taper dans une console sont précédées par une légende pour indiquer sur quel environnement elles doivent être exécutées.

Exemple avec une commande qui devra être tapée dans la console de ton ordinateur (PC) :

```{code-block} shell
  :caption: 🖥️ Ordinateur (PC)

echo "Coucou depuis l'ordi !"
```

Et une commande qui devra être tapée dans la console du serveur (<abbr title="Virtual Private Server">VPS</abbr>) sur lequel le nœud sera deployé :

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
Le mot de passe que tu créeras pour ce compte doit faire **8 caractères ou plus**.
```

Nous devons passer par Geth pour la création du compte.

Donc, sur ton PC, installe Geth :

```{code-block} shell
  :caption: 🖥️ Ordinateur (PC)

wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.11-8f7eb9cc.tar.gz \
    && tar -xzf geth-linux-amd64-1.13.11-8f7eb9cc.tar.gz \
    && cd geth-linux-amd64-1.13.11-8f7eb9cc \
    && echo "OK"
```

Et créé le compte :
```{code-block} shell
  :caption: 🖥️ Ordinateur (PC)

./geth account new --keystore ./keystore \
    && echo "OK"
```

```{caution}
Garde bien les informations en sécurité (le mot de passe et le fichier contenant la clef privée).
```

Le fichier de la clef privée se trouve dans le dossier **keystore** et se nomme quelque chose comme **UTC--xxx** (où "xxx" est spécifique à chacun).

---

## Hébergement

C'est l'heure de raquer : créé ton compte sur Contabo, et uitlise [ce lien](https://contabo.com/en/vps/cloud-vps-2/?image=debian.329&qty=1&contract=1&storage-type=vps-2-200-gb-nvme) vers le serveur à louer avec la bonne configuration préselectionnée.
À l'heure où j'écris ces lignes, la première facture est de 18,60 €, puis 11,40 €/mois.

Quand tu auras reçu le 2<sup>nd</sup> email avec l'adresse IP du serveur, envoie le fichier de la clef privée (remplace `ADRESSE_IP` par l'adresse IP du serveur) :

```{code-block} shell
  :caption: 🖥️ Ordinateur (PC) ✍️
  :emphasize-lines: 1

scp keystore/UTC--* root@ADRESSE_IP:/root \
    && echo "OK"
```

Puis connecte-toi en SSH au serveur (utilise le mot de passe que tu as définis sur Contabo  et remplace `ADRESSE_IP` par l'adresse IP du serveur) :

```{code-block} shell
  :caption: 🖥️ Ordinateur (PC) ✍️

ssh root@ADRESSE_IP
```

---

## Installation

Mets à jour le système d'exploitation :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

apt update \
    && apt full-upgrade -y \
    && apt autoremove -y \
    && echo "OK"
```

Installe le pare-feu, puis redémarre :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

apt install -y ufw \
    && ufw allow ssh \
    && ufw allow 9151/tcp \
    && reboot
```

Patiente quelques secondes, reconnecte-toi, puis installe Docker :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && echo "OK"
```

Pré-requis pour la prochaine étape :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

mkdir nulink \
    && mv UTC--* nulink/ \
    && chmod -R 777 nulink \
    && echo "OK"
```

Enfin, installe NuLink :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

docker pull nulink/nulink:latest \
    && echo "OK"
```

---

## Configuration

```{tip}
Envoie maintenant un peu de tBNB sur le compte du *worker*.
```

Enregistre les mots de passe pour plus tard :

```{code-block} shell
  :caption: ☁️  Serveur (VPS) ✍️

echo "export NULINK_KEYSTORE_PASSWORD='TON_MOT_DE_PASSE_POUR_NULINK'" >> ~/.profile
```
```{code-block} shell
  :caption: ☁️  Serveur (VPS) ✍️

echo "export NULINK_OPERATOR_ETH_PASSWORD='LE_MOT_DE_PASSE_DU_COMPTE_WORKER'" >> ~/.profile
```

Tu dois te déconnecter pour prendr en compte les changements :
```{code-block} shell
  :caption: ☁️ Serveur (VPS)

exit
```

Reconnecte-toi, et teste que les mots de passe sont visibles (tu devrais voir 3 lignes avec les 2 mots de passes et "OK") :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

echo $NULINK_KEYSTORE_PASSWORD \
    && echo $NULINK_OPERATOR_ETH_PASSWORD \
    && echo "OK"
```

Initialise NuLink (remplace `FICHIER_CLEF_PRIVEE` par le nom du fichier contenant la clef privée du compte *worker* ["UTC--xxx"] et `ADRESSE_WORKER` par l'addresse publique du compte *worker*) :

```{code-block} shell
  :caption: ☁️  Serveur (VPS) ✍️
  :emphasize-lines: 7,12

docker run -it --rm \
    -p 9151:9151 \
    -v /root/nulink:/code \
    -v /root/nulink:/home/circleci/.local/share/nulink \
    -e NULINK_KEYSTORE_PASSWORD \
    nulink/nulink nulink ursula init \
    --signer keystore:///code/FICHIER_CLEF_PRIVEE \
    --eth-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
    --network horus \
    --payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
    --payment-network bsc_testnet \
    --operator-address ADRESSE_WORKER \
    --max-gas-price 10000000000 \
    && echo "OK"
```

```{caution}
Garde bien les informations en sécurité (les douze mots de la *seed phrase* et le fichier contenant la clef privée).
```

Depuis ton PC, récupère une copie de la clef privée (remplace `ADRESSE_IP` par l'adresse IP du serveur) :

```{code-block} shell
  :caption: 🖥️ Ordinateur (PC) ✍️
  :emphasize-lines: 1

scp root@ADRESSE_IP:'/root/nulink/keystore/*' . \
    && echo "OK"
```

---

## Exécution

Et c'est parti, démarre ton nœud :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

docker run --restart on-failure -d \
    --name ursula \
    -p 9151:9151 \
    -v /root/nulink:/code \
    -v /root/nulink:/home/circleci/.local/share/nulink \
    -e NULINK_KEYSTORE_PASSWORD \
    -e NULINK_OPERATOR_ETH_PASSWORD 
    nulink/nulink nulink ursula run --no-block-until-ready \
    && echo "OK"
```

Pour voir les logs :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

docker logs -f ursula
```

Si tu vois « *Working ~ Keep Ursula Online!* » et/ou « *learn_from_teacher_node stop now RELAX.* », ça veut dire que tout fonctionne nickel. Féliciations !

---

## Lier les Comptes

Le site web pour la gestion du staking est [https://dashboard.testnet.nulink.org/staking](https://dashboard.testnet.nulink.org/staking).
Plus bas dans cette page, il y a un bouton « *Bond worker* », clique dessus et renseigne l'adresse du compte *worker*. Et voilà !

---

## Mises à Jour

Lors d'une [mise à jour du nœud](https://github.com/NuLink-network/nulink-core/releases), voici les étapes à suivre pour appliquer les changements sur le serveur :

```{code-block} shell
  :caption: ☁️ Serveur (VPS)

# Suppression du conteneur actuel, puis installation de la dernière version
docker stop ursula \
    && docker rm ursula \
    && docker pull nulink/nulink:latest \
    && echo "OK"
```

Pour terminer, relance le [nœud](#execution).

---

## Historique

- 2024-01-27 : Premier jet.
