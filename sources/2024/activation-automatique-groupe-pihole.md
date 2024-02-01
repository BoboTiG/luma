# Activation automatique d'un groupe sur Pi-hole

Le contexte est simple : j'ai un Mac pour le boulot, et il s'avère qu'il communique en permanence avec Apple et d'autres serveurs même lorsqu'il est **censé être en veille**. Donc, aux grands maux les gros moyens : coupure de tout le trafic hors des heures de travail.
L'idée peut être appliquée à d'autres fins comme bloquer l'accès aux réseaux sociaux pendant les heures de travail/cours, etc.

Pour mon exemple, dans [Pi-hole](https://pi-hole.net), j'ai ajouté un groupe "work" et placé le Mac dans ce dernier.
J'ai ajouté le domaine `.*` à la *blacklist* (ça veut dire tous les domaines), puis l'ai assigné à ce groupe.

Ensuite, se connecter en SSH à la machine qui héberge Pi-hole, puis :

```{code-block} shell
su
crontab -e
```

Et insérer ces lignes (à adapter selon les besoins, [Crontab.guru](https://crontab.guru) peut être utile) :

```{code-block} shell
# Activation du trafic à 9:00, du lundi au vendredi
0 9 * * 1-5 sqlite3 /etc/pihole/gravity.db "update 'group' set enabled = 0 where name = 'work'"
1 9 * * 1-5 PATH="$PATH:/usr/sbin:/usr/local/bin/" pihole restartdns

# Désactivation du trafic à 19:00, du lundi au vendredi
0 19 * * 1-5 sqlite3 /etc/pihole/gravity.db "update 'group' set enabled = 1 where name = 'work'"
1 19 * * 1-5 PATH="$PATH:/usr/sbin:/usr/local/bin/" pihole restartdns
```

Étant donné que le dernier cronjob se lancera le vendredi à 19h, l'accès sera coupé tout le week-end, jusqu'au lundi matin suivant, à 9h.

---

## 📜 Historique

2024-01-27
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2024/01/09/00/32/31-activation-automatique-dun-groupe-sur-pi-hole).

2024-01-09
: Premier jet.
