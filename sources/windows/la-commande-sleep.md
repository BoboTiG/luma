# La commande `sleep` pour Windows

> En fait, elle n’existe pas.

Étant donné qu’il n’existe pas de commande `sleep` sur Windows, nous pouvons tenter de l’émuler ou trouver des alternatives.

## `timeout`

Windows est livré avec une commande qui s’appelle `timeout`, située dans le dossier `C:\Windows\System32`, et qui pourrait faire l’affaire. Par exemple, pour faire une pause de 5 secondes :

```{literalinclude} snippets/la-commande-sleep.bat
:lines: 3
:language: batch
```

Cependant, bien que cette commande fonctionnera la plupart du temps, il se peut que cette erreur survienne :

```{code-block}
timeout: invalid time interval ‘/t’
Try 'timeout --help' for more information.
```

Ce problème arrive lorsque Cygwin est installé. Dans ce cas, il s’agira de l’exécutable fourni par Cygwin et non celui de Windows. Ceci est du fait que Cygwin modifie le chemin de recherche des exécutables et prend l’ascendance sur les dossiers du système. Et il s’avère que la version de la commande `timeout` de Cygwin ne prend pas les mêmes arguments.

Un correctif possible est d’utiliser le chemin complet de l’exécutable :

```{literalinclude} snippets/la-commande-sleep.bat
:lines: 4
:language: batch
```

## `ping`

Il existe une alternative universelle : `ping`. C’est une astuce vieille comme Windows, mais qu’il fallait connaître :

```{literalinclude} snippets/la-commande-sleep.bat
:lines: 6
:language: batch
```

L’idée, c’est de *pinger* l’adresse locale N fois pour une pause de N secondes.
Comme `ping` utilise un [intervalle de une seconde](seconde-d-intervalle) entre chaque essai, il faut utiliser `-n N+1` pour simuler une pause de N secondes. Dans cet exemple, `-n 6` permet donc de faire une pause de 5 secondes.

### Une Seconde d’Intervalle ?

L’implémentation de [ReactOS](https://reactos.org) permet de le vérifier :

```{literalinclude} snippets/la-commande-sleep.c
:caption: ping.c
:language: c
```

## 🎣 Source

- [reactos/reactos ping.c](https://github.com/reactos/reactos/blob/893a3c9d030fd8b078cbd747eeefd3f6ce57e560/base/applications/network/ping/ping.c#L145-L155).

## 📜 Historique

2024-02-07
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2019/10/17/16/53/57-la-commande-sleep).

2020-08-08
: Premier jet.
