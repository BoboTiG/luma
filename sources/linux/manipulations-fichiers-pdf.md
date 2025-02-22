# Manipulation de fichiers PDF

[PDFtk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit) est un outil puissant pour la manipulation de fichiers PDF.

Il existe aussi un service en ligne, avec possibilité d’auto-hébergement, se nommant [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) et qui propose une vaste panoplie d’actions sur les fichiers PDF, comme l’ajout d’une signature ou d’un filigrane, par exemple. Voici une instance disponible : [3n1 Tech Solutions](https://pdf.3n1tech.com/?lang=fr_FR).

## Sécuriser

Avant toute chose, si un document provient d’une source douteuse, [Dangerzone](https://dangerzone.rocks) permettra de l’assainir.

## Déprotéger

Admettons que le fichier PDF soit protégé par mot de passe, et que celui-ci est connu. Voici comment en faire une copie non protégée :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 42
:language: shell
```

## Orienter

Pour l’exemple, disons que les pages 301, 302 et 303 du fichier source sont en mode paysage alors que toutes les autres sont en mode portrait. Voici comment réorienter ces 3 pages :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 3-10
:language: shell
```

## Redimensionner

Pour vérifier que toutes les pages ont les mêmes marges :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 12
:language: shell
```

Exemple de sortie :

```{code-block}
/MediaBox [0 0 595 842]
/MediaBox [0 0 612 792]
```

Redimensionnons toutes les pages :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 13-15
:language: shell
```

## Fusionner

Pour fusionner plusieurs fichiers PDF en un seul :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 17-22
:language: shell
```

## Extraire

Pour extraire une ou plusieurs pages d’un fichier PDF :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 44
:language: shell
```

## Optimiser

`GhostScript` permet de réduire grandement le poids du fichier final :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 32-37
:language: shell
```

## Personnaliser les Méta-données

Exporter les métadonnées actuelles dans le fichier `metadata.txt` :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 39
:language: shell
```

Le contenu du fichier ressemble à ça :

```{code-block}
InfoBegin
InfoKey: ModDate
InfoValue: D:20191114220102Z
InfoBegin
InfoKey: Producer
InfoValue: PRODUCTER
PdfID0: d8ec8095099bebfa395c663ac4e4a26e
PdfID1: 6f977277cf1bfe9a5b8c1c60f2ba175d
NumberOfPages: 158
PageMediaBegin
PageMediaNumber: 1
PageMediaRotation: 0
PageMediaRect: 0 8.58 1,057.5 1,696.08
PageMediaDimensions: 1,057.5 1,687.5
…
```

Modifier les premières lignes ou ajouter les métadonnées manquantes (parmi : *Title*, *Author*, *Subject*, *Keywords*, *Creator*, *Producer*, *CreationDate*, *ModDate* et *Trapped*) :

```{code-block}
:emphasize-lines: 1-9

InfoBegin
InfoKey: Title
InfoValue: TITLE
InfoBegin
InfoKey: Author
InfoValue: AUTHOR
InfoBegin
InfoKey: CreationDate
InfoValue: D:20191114220102Z
InfoBegin
InfoKey: ModDate
InfoValue: D:20200409101248Z
InfoBegin
InfoKey: Producer
InfoValue: PRODUCTER
PdfID0: d8ec8095099bebfa395c663ac4e4a26e
PdfID1: 6f977277cf1bfe9a5b8c1c60f2ba175d
NumberOfPages: 158
PageMediaBegin
PageMediaNumber: 1
PageMediaRotation: 0
PageMediaRect: 0 8.58 1,057.5 1,696.08
PageMediaDimensions: 1,057.5 1,687.5
…
```

Générer un nouveau PDF comportant les nouvelles méta-données :

```{literalinclude} snippets/manipulations-fichiers-pdf.sh
:lines: 40
:language: shell
```

## 📜 Historique

2025-02-22
: Ajout de la section [Extraire](#extraire).

2024-08-30
: Ajout de la section [Sécuriser](#securiser).
: Ajout des informations sur Stirling-PDF dans l’introduction.

2024-05-14
: Ajout de la section [Déprotéger](#deproteger).

2024-02-07
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2019/12/07/14/59/33-manipulation-de-fichiers-pdf).

2020-04-09
: Ajout de la section [Personnaliser les Méta-données](#personnaliser-les-meta-donnees).

2019-12-17
: Premier jet.
