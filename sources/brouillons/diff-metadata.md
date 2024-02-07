# Comprendre les méta-données de diff

Voici la sortie de `git diff` sur un fichier lambda :

```{literalinclude} snippets/diff-metadata.diff
    :caption: https://github.com/gorakhargosh/watchdog/issues/1025
    :linenos:
    :emphasize-lines: 2
    :language: diff
```

Voyons de quoi se compose la ligne n° 2 :

```{literalinclude} snippets/diff-metadata.diff
    :lines: 2
    :language: diff
```

```{literalinclude} snippets/diff-metadata.c
    :caption: diff.c
    :lines: 2-
    :language: c
```

---

## 🎣 Sources

- [git/git diff.c](https://github.com/git/git/blob/v2.43.0/diff.c#L4480-L4484)

## 📜 Historique

2024-02-07
: Premier jet.
