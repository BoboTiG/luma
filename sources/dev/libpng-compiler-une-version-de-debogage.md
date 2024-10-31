# Compiler une version de débogage de libpng

## Télécharger

```{literalinclude} snippets/libpng-compiler-une-version-de-debogage.sh
:lines: 3-4
:language: shell
```

## Compiler

La partie importante permettant d’activer le débogage est `CPPFLAGS=-DPNG_DEBUG=2` :

```{literalinclude} snippets/libpng-compiler-une-version-de-debogage.sh
:lines: 6-8
:language: shell
```

## Tester

Remplacer `IMAGE` par un fichier PNG :

```{literalinclude} snippets/libpng-compiler-une-version-de-debogage.sh
:lines: 10
:language: shell
```

---

## 📜 Historique

2024-02-01
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2016/04/11/13/42/33-libpng-compiler-une-version-de-debogage).

2016-04-11
: Premier jet.
