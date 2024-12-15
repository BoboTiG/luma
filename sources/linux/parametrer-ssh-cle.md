# Comment paramétrer SSH pour un accès par clé

## 🚪 Pourquoi ?

D'un point de vue sécurité, accéder à une machine distante via SSH à l'aide d'un mot de passe n'est pas recommandé.

Que `fail2ban` soit en place ou non, il est possible de se rendre compte à quel point ladite machine peut être ciblée par des utilisateurs peu scrupuleux :

```{literalinclude} snippets/parametrer-ssh-cle.sh
:caption: ☁️ Serveur
:lines: 19-20
:language: shell
```

Autre point intéressant pour les personnes fainéantes : l'utilisation d'une clé fait gagner du temps, car plus besoin de se souvenir et taper de mot de passe.

---

## 🔑 Générer la clé locale

Depuis l'ordinateur d'où l'on souhaite se connecter :

```{literalinclude} snippets/parametrer-ssh-cle.sh
:caption: 🖥️ Ordinateur
:lines: 3-4
:language: shell
```

Les fichiers `~/.ssh/id_ed25519` (la clé privée) et `~/.ssh/id_ed25519.pub` (la clé publique) seront créés.

Ensuite, paramétrer la configuration locale pour utiliser cette nouvelle clé.
Adapter les lignes surlignées, ou, en cas de configuration existante, le nouveau contenu important se situe lignes 6 et 7 :

```{literalinclude} snippets/parametrer-ssh-cle.sh
:caption: 🖥️ Ordinateur ✍️ 
:lines: 6-13
:emphasize-lines: 2-4
:linenos:
:language: shell
```

---

## 🔒 Importer la clé sur la machine distante

Depuis la machine sur laquelle la connexion par clé est souhaitée (remplacer, à la seconde ligne, `<id_ed25519.pub>` par le contenu du fichier local `~/.ssh/id_ed25519.pub`) :

```{literalinclude} snippets/parametrer-ssh-cle.sh
:caption: ☁️ Serveur
:lines: 15-17
:emphasize-lines: 2
:language: shell
```

```{important}
Vérifier maintenant que l'accès par clé fonctionne avant d'aller plus loin.
```

Dernière étape, désactiver l'accès par mot de passe :

```{literalinclude} snippets/parametrer-ssh-cle.sh
:caption: ☁️ Serveur
:lines: 22-24
:language: shell
```

### 🍰 Bonus

Pour que ça en jette plus (et/ou pour s'y retrouver plus facilement lorsqu'il y a plusieurs machines distantes), générer un super {abbr}`MOTD (Message Of The Day)` grâce à [Text to ASCII Art Generator (TAAG)](https://patorjk.com/software/taag/). Copier le résultat dans le fichier `/etc/motd`.

---

## 📜 Historique

2024-12-15
: Premier jet.
