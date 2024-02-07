# Comment déployer un nœud Dusk ?

```{figure} images/dusk-logo.svg
 :width: 96
  :height: 96
  :alt: NuLink Logo
  :align: center

  Site web : [dusk.network](https://dusk.network)
```

```{attention}
Cet article est en cours de rédaction.
```

Ce guide est une traduction libre et simplifiée de la [documentation officielle](https://docs.nulink.org/products/stakers/nulink_worker/) pour le déploiement d'un nœud Dusk, plus communément appelé *node validator*, *worker node* ou encore *staker node*.

Configuration requise :

- système d'exploitation : **Debian** GNU/Linux
- architecture : x86-64
- espace disque : 250 Gio
- mémoire : 4 Gio de RAM

À savoir, il te faudra 2 comptes :
1. un compte *staker* qui *stake* ses [tDUSK](https://testnet.bscscan.com/token/0xa22bfb00be8938c50833bfd2444ec721a9eeacc1), n'importe quel compte Metamask ou Rabby fait l'affaire ;
2. un compte *worker* qui sera lié au compte *staker* (on parle de *bond* en anglais), et nous allons voir tout de suite comment le générer.

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

## 📜 Historique

2024-01-27
: Premier jet.
