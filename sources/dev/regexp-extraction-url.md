# RegExp d'extraction d'URL

Voici la RegExp en question : `https?://[^\s<"]+`.

L'astuce réside dans le fait qu'il ne peut pas avoir d'espace dans une URL. L'expression ci-dessus va rechercher tous les caractères et s'arrêtera lorsqu'elle tombera sur un "espace blanc" (c'est-à-dire un espace, un retour chariot, une tabulation, un saut de ligne ou un saut de page). Il ne peut pas avoir non plus ni de guillemet anglais (`"`), ni de signe inférieur, qui signifie l'ouverture d'une balise HTML.

`````{tabs}

````{tab} javaScript
```{code-block} javascript
text = text.replace(/(https?:\/\/[^\s<"]+)/g, '< href="$1">$1</a>');
```
````

````{tab} Perl
```{code-block} perl
$text =~ s#(https?://[^\s<"]+)#<a href="$1">$1</a>#g;
```
````

````{tab} PHP
```{code-block} php
$text = preg_match('/(https?:\/\/[^\s<"]+)/g', '<a href="$1">$1</a>', $text);
```
````

````{tab} Python
```{code-block} python
import re
text = re.sub(r'(https?://[^\s<"]+)', r'<a href="\1">\1</a>', text)
```
````

`````

---

## 📜 Historique

2024-04-06
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2015/02/16/10/17/49-code-url-to-link).

2015-05-11
: Amélioration de la RegExp (`https?://[^\s]+` → `https?://[^\s<"]+`).

2015-05-10
: Premier jet.
