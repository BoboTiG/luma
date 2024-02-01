# Git : Supprimer les tags datant de plus de N jours

Ce morceau de code supprimera tous les tags datant de plus de 21 jours.

À adapter selon les besoin :

- ligne 13 : la limite du nombre de jours ;
- ligne 18 : le filtrage (optionnel) sur le nom des tags (seuls ceux commençant par *alpha-* sont pris en compte, dans cet exemple).

```{literalinclude} snippets/git-supprimer-les-tags-datant-de-plus-de-njours.sh
    :lines: 3-
    :linenos:
    :emphasize-lines: 13,18
    :language: shell
```

---

## Sources

- [https://stackoverflow.com/questions/48629441/remove-remote-git-tags-older-than-x-months/48669841#48669841](https://stackoverflow.com/a/48669841/1117028)
- [https://stackoverflow.com/questions/4946785/how-to-find-the-difference-in-days-between-two-dates/6948865#6948865](https://stackoverflow.com/a/6948865/1117028)

---

## 📜 Historique

2024-01-31
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2020/08/03/11/02/46-git-supprimer-les-tags-datant-de-plus-de-n-jours).

2020-08-08
: Premier jet.
