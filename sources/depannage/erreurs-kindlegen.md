# Les erreurs de kindlegen

Bien qu'abandonné depuis 2014 par Amazon, `kindlegen` reste le meilleur outil, à cette date, pour créer un dictionnaire au format *Mobipocket* (`.mobi`).

````{hint}
Ces arguments *cachés* peuvent être utiles lors de l'utilisation de `kindlegen` :

```{code-block} console
$ kindlegen -gen_ff_mobi7 -dont_append_source -verbose ...
```
````

## ⚠️ Avertissements

### W14010: Media file not found

````{card} L'image n'est pas trouvée :
```{code-block}
Warning(prcgen):W14010: media file not found  /.../OEBPS/xxx.gif
```
+++
{bdg-danger}`Solution`
Inconnue, je n'ai aucune idée où sont stockées les images.
````

### W14024: Unrecognized language code

````{card} Code langue inconnu :
```{code-block}
Warning(prcgen):W14024: Unrecognized language code in dc:Language metadata field.
```
+++
{bdg-success}`Solution`
Remplacer le code langue inconnu par une langue supportée. Par exemple, l'Esperanto (`eo`) n'est pas reconnu et peut-être remplacé par le Français (`fr`) car c'est la seule langue qui est à la fois supportée et proche de l'Esperanto.
````

### W14215: Nested tags are not supported

````{card} L'imbrication des balises HTML n'est pas supportée :
```{code-block}
 Warning(prcgen):W14215: nested <FORM> tags are not supported
      in file: /.../OEBPS/g000002.xhtml     line: 0005725
```
+++
{bdg-success}`Solution`
Généralement du à un mauvais code HTML, ou à des accolades (`{` et/ou `}`) présentes dans ledit code. Ouvrir le fichier `/.../OEBPS/g000002.xhtml` à la ligne `5725` pour voir de quel mot il s'agit, puis corriger l'origine du problème débouchant sur du code HTML erroné.

Voici une ligne de commande pratique pour afficher les 10 lignes pertinentes :
```{code-block} console
$ awk 'NR >= 5775-10 && NR <= 5775' /.../OEBPS/g000002.xhtml
````

### W14216: Tag does not have a name attribute

````{card} La balise HTML n'a pas d'attribut :
```{code-block}
Warning(prcgen):W14216: tag does not have a name attribute : tag will be ignored
      in file: /.../OEBPS/g000002.xhtml     line: 0005725
```
+++
{bdg-success}`Solution`
Généralement du à un mauvais code HTML, ou à des accolades (`{` et/ou `}`) présentes dans ledit code. Ouvrir le fichier `/.../OEBPS/g000002.xhtml` à la ligne `5725` pour voir de quel mot il s'agit, puis corriger l'origine du problème débouchant sur du code HTML erroné.

Voici une ligne de commande pratique pour afficher les 10 lignes pertinentes :
```{code-block} console
$ awk 'NR >= 5775-10 && NR <= 5775' /.../OEBPS/g000002.xhtml
````

### W15003: Unicode string too long

````{card} Au moins un mot contient plus de 127 caractères :
```{code-block}
Warning(index build):W15003: unicode string too long (max=127). Truncated.
```
+++
{bdg-success}`Solution`
Tronquer, voire supprimer, les mots de plus de 127 caractères.
````

### W29004: Forcefully closed opened tag

````{card} Fermeture forcée d'une balise HTML :
```{code-block}
Warning(inputpreprocessor):W29004: Forcefully closed opened Tag: <p>
      in file: /.../OEBPS/g000002.xhtml     line: 0005725
```
+++
{bdg-success}`Solution`
Généralement du à un mauvais code HTML, ou à des accolades (`{` et/ou `}`) présentes dans ledit code. Ouvrir le fichier `/.../OEBPS/g000002.xhtml` à la ligne `5725` pour voir de quel mot il s'agit, puis corriger l'origine du problème débouchant sur du code HTML erroné.

Voici une ligne de commande pratique pour afficher les 10 lignes pertinentes :
```{code-block} console
$ awk 'NR >= 5775-10 && NR <= 5775' /.../OEBPS/g000002.xhtml
```
````

### W29007: Rejected unknown tag

````{card} Balaise HTML inconnue :
```{code-block}
Warning(inputpreprocessor):W29007: Rejected unknown tag: <bdi>
      in file: /.../OEBPS/g000002.xhtml     line: 0005725
```
+++
{bdg-success}`Solution`
Supprimer, ou adapter, le code HTML pour se passer des balises non supportées.

Voici une ligne de commande pratique pour afficher les 10 lignes pertinentes :
```{code-block} console
$ awk 'NR >= 5775-10 && NR <= 5775' /.../OEBPS/g000002.xhtml
```
````

## 😱 Erreurs

### E25002: Single entry exceeds record size

````{card} Erreur interne critique :
```{code-block}
Error(index build):E25002: single entry exceeds record size (max=64k): aborting index build.
```
+++
{bdg-danger}`Solution`
Recherche en cours...
````

### E25006: Overflowing character table in Unicode

````{card} Trop de caractères différents sont utilisés :
```{code-block}
Error(index build):E25006: overflowing character table in UNICODE: in indexes, you can use a total of 256 different characters from the following unicode ranges: U+0000-U+02FF(latin), U+3000-U+30FF(kana), U+FF00-U+FF9F(alt. width latin+kana).
```
+++
{bdg-success}`Solution`
Pour la totalité du dictionnaire, répertorier quels mots utilisent quels caractères.
Ensuite, en démarrant avec les caractères les moins utilisés, supprimer les mots correspondants.
À chaque itération, vérifier que le nombre total de caractères n'excède pas `256`, sinon supprimer les mots du second caractère le moins utilisé.
Et ainsi de suite jusqu'à ce que le nombre total de caractères arrive à **`256` maximum**.

Les caractères comptabilisés sont dans le mot en lui-même, ses étymologies et ses définitions.

Du code Python spécifique au projet [eBook Reader Dictionaries](https://github.com/BoboTiG/ebook-reader-dict) est disponible dans le [fichier convert.py](https://github.com/BoboTiG/ebook-reader-dict/blob/4a1852f7aba70a0a389abfb7d1b895e90797d1d0/wikidict/convert.py#L569-L624).
````

### Double free or corruption

````{card} Erreur interne critique :
```{code-block}
*** glibc detected *** /.../kindlegen: double free or corruption (!prev): 0x1ddd45a8 ***
======= Backtrace: =========
[0x8813970]
(...)
[0x882a39e]
======= Memory map: ========
08048000-09b61000 r-xp 00000000 103:02 23986212                          /.../kindlegen
09b61000-09b93000 rw-p 01b19000 103:02 23986212                          /.../kindlegen
09b93000-09bda000 rw-p 00000000 00:00 0 
0ae2f000-24dda000 rw-p 00000000 00:00 0                                  [heap]
c6d00000-c6d90000 rw-p 00000000 00:00 0 
(...)
f72e0000-f7ae0000 rw-p 00000000 00:00 0 
f7ae0000-f7d59000 r--p 00073000 103:02 23352947                          /usr/lib/locale/locale-archive
f7d59000-f7f59000 r--p 00000000 103:02 23352947                          /usr/lib/locale/locale-archive
f7fab000-f7fad000 rw-p 00000000 00:00 0 
f7fad000-f7fb1000 r--p 00000000 00:00 0                                  [vvar]
f7fb1000-f7fb3000 r-xp 00000000 00:00 0                                  [vdso]
ffa64000-ffa87000 rw-p 00000000 00:00 0                                  [stack]
```
+++
{bdg-danger}`Solution`
Aucune.
````

## 📜 Historique

2025-04-02
: Premier jet.
