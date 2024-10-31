# Windows : Outrepasser l’écran de connexion

Il existe une astuce, *vieille comme Windows NT*, qui permet d’avoir un **accès privilégié à l’invite de commande** (ou console, ou terminal) à l’écran de connexion de l’utilisateur. Il s’agit du bon vieux `Utilman.exe`. L’idée est de le substituer à l’invite de commande (`cmd.exe`) et de créer un nouvel utilisateur.

```{hint}
Utilman est l’utilitaire qui donne accès aux options d’ergonomie, la petite icône en bas à gauche de l’écran de connexion.
```

## ♻️ Substituer Utilman

Commencez par démarrer sur un système d’exploitation alternatif, du genre [SystemRescueCD](http://www.sysresccd.org), à partir d’une clé USB ou d’un CD. Toute autre distribution GNU/Linux fera l’affaire, question de goût.
Ensuite, montez la partition qui contient Windows.

Pour lister les différentes partitions :

```{literalinclude} snippets/outrepasser-ecran-de-connexion.sh
:lines: 3
:language: shell
```

Monter la bonne partition :

```{literalinclude} snippets/outrepasser-ecran-de-connexion.sh
:lines: 5
:language: shell
```

Enfin, la substitution :

```{literalinclude} snippets/outrepasser-ecran-de-connexion.sh
:lines: 7-10
:language: shell
```

Finalement, redémarrez sur Windows et cliquez sur l’icône "*Option d’ergonomie*".

Voilà, vous avez **un accès privilégié à l’invite de commande** !

---

## 🕵️‍♂️ Créer un Utilisateur

Vous voilà dans l’invite de commande. Voici les commandes pour créer un nouvel utilisateur, disons Bob :

```{literalinclude} snippets/outrepasser-ecran-de-connexion.bat
:lines: 3-6
:language: batch
```

Vous pouvez assigner Bob au groupe *administrateurs*.

```{caution}
`administrateurs` est le nom du groupe sur une version française de Windows. À adapter suivant la langue du système.

Autres langues :
- anglais : *administrators*
```

```{literalinclude} snippets/outrepasser-ecran-de-connexion.bat
:lines: 8-9
:language: batch
```

Il ne reste plus qu’à vous connecter à l’aide de l’identifiant Bob.

---

## 📜 Historique

2024-02-01
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2015/08/19/12/04/21-outrepasser-lecran-de-connexion).

2015-08-19
: Premier jet.
