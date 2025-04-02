# Retrouver son mot de passe grâce à John the Ripper

Admettons que vous ayez perdu l’accès à votre système tournant sous GNU/Linux, et vous avez un accès physique à la machine en question.

## 🕵️ Installer John the Ripper

### 💾 Clôner

```{literalinclude} snippets/retrouver-son-mot-de-passe-avec-john.sh
:lines: 3-4
:language: shell
```

````{admonition} En cas d’erreur
:class: toggle

Si cette erreur survient :

```{code-block}
error: RPC failed; curl 92 HTTP/2 stream 5 was not closed cleanly: CANCEL (err 8)
error: 4038 bytes of body are still expected
fetch-pack: unexpected disconnect while reading sideband packet
fatal: early EOF
fatal: fetch-pack: invalid index-pack output
```

Alors désactiver la compression, puis relancer la commande de clônage :

```{code-block} console
$ git config --global core.compression 0
```
````

### 🛠️ Compiler

```{literalinclude} snippets/retrouver-son-mot-de-passe-avec-john.sh
:lines: 6-10
:language: shell
```

## 🌓 Faire la Lumière

Générer le fichier contenant le hash qui nous intéresse :

```{literalinclude} snippets/retrouver-son-mot-de-passe-avec-john.sh
:lines: 12
:language: shell
```

````{admonition} Exemple de contenu de ~/unshadowed.txt
:class: toggle

```{code-block} text
alice:$6$xxx.:1000:1000::/home/alice:/bin/zsh
```
````

## 🔓 Cracker

Pour l’exemple, je me souviens du format du mot de passe :

- le début est `jvd` ou `JVD` ou n’importe quelle combinaison de casse ;
- ensuite viendrait le caractère `@` ;
- puis une année.

Cela se traduit par cette commande :

```{literalinclude} snippets/retrouver-son-mot-de-passe-avec-john.sh
:lines: 14-17
:language: shell
```

````{admonition} Et bingo !
:class: toggle

```{code-block}
:emphasize-lines: 6

Using default input encoding: UTF-8
Loaded 1 password hash (sha512crypt, crypt(3) $6$ [SHA512 512/512 AVX512BW 8x])
Cost 1 (iteration count) is 5000 for all loaded hashes
Will run 14 OpenMP threads
Press ’q’ or Ctrl-C to abort, ’h’ for help, almost any other key for status
JVD@2012         (alice)     
1g 0:00:00:01 DONE (2024-12-02 22:09) 0.9174g/s 46033p/s 46033c/s 46033C/s jvd@4285..JVD@1726
Use the "--show" option to display all of the cracked passwords reliably
Session completed.
```
````

## 📜 Historique

2024-12-02
: Premier jet.
