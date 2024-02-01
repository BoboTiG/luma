# Windows : Outrepasser l'écran de connexion

Il existe une astuce, valable depuis un bail, qui permet d'avoir un **accès privilégié à l'invite de commande** (ou console, ou terminal) à l'écran de connexion de l'utilisateur. Il s'agit du bon vieux `Utilman.exe`. Utilman est l'utilitaire qui donne accès aux options d'ergonomie, la petite icône en bas à gauche de l'écran de connexion. L'idée est de le substituer à l'invite de commande (`cmd.exe`) et de créer un nouvel utilisateur.

## Substitution de `Utilman.exe`

### Monter la Partition

Commencez par démarrer sur un système d'exploitation alternatif, du genre [SystemRescueCD](http://www.sysresccd.org), à partir d'une clef USB ou d'un CD. Tout autre distribution GNU/Linux fera l'affaire, question de goût.
Ensuite, montez la partition qui contient Windows.

Pour lister les différentes partitions :

```{literalinclude} snippets/windows-outrepasser-ecran-de-connexion.sh
    :lines: 3
    :language: shell
```

Monter la bonne partition :

```{literalinclude} snippets/windows-outrepasser-ecran-de-connexion.sh
    :lines: 5
    :language: shell
```

### Substituer `Utilman.exe`

```{literalinclude} snippets/windows-outrepasser-ecran-de-connexion.sh
 :lines: 7-9
    :language: shell
```

Finalement, redémarrez sur Windows et cliquez sur l'icône « *Option d'ergonomie* ».

Voilà, vous avez **un accès privilégié à l'invite de commande** !

---

## Création de l'Utilisateur

Vous voilà dans l'invite de commande. Voici les commandes pour créer un nouvel utilisateur, disons **Bob** :

```{literalinclude} snippets/windows-outrepasser-ecran-de-connexion.bat
    :lines: 3-6
    :language: batch
```

Vous pouvez assigner Bob au groupe *administrateurs* :

```{literalinclude} snippets/windows-outrepasser-ecran-de-connexion.bat
    :lines: 8-9
    :language: batch
```

Il ne reste plus qu'à vous connecter à l'aide de l'identifiant Bob.

---

## 📜 Historique

2024-02-01
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2015/08/19/12/04/21-windows-outrepasser-lecran-de-connexion).

2015-08-19
: Premier jet.
