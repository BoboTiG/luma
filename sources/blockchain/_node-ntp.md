<!-- pyml disable-next-line first-line-heading -->
Pour être compétitif, le nœud doit rester synchronisé par rapport à ses pairs. Voyons comment faire en sorte d'utiliser un service NTP efficace.

D'abord, vérifier que le fuseau horaire est correct :

```{literalinclude} snippets/_node-ntp.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 3
    :language: shell
```

````{admonition} Exemple de sortie
    :class: toggle

```{code-block}
    :emphasize-lines: 4

               Local time: Fri 2024-02-16 22:41:05 CET
           Universal time: Fri 2024-02-16 21:41:05 UTC
                 RTC time: Fri 2024-02-16 21:41:05
                Time zone: Europe/Berlin (CET, +0100)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```
````

````{admonition} Si le fuseau horaire est incorrect...
    :class: toggle

[Time.is](https://time.is) est un service en ligne qui permet de trouver le nom du fuseau horaire d'une ville donnée. Dans le champ de recherche, entrer "Paris", par exemple, puis valider en appuyant sur {kbd}`Entrée`. Dans la page résultante, rechercher le texte "*The IANA time zone identifier*" ; en l'occurrence ça donne "*The IANA time zone identifier for Paris is Europe/Paris*".
Le fuseau horaire est *Europe/Paris*, et voici comment spécifier cette valeur au serveur :

```{literalinclude} snippets/_node-ntp.sh
    :caption: ☁️ Serveur (VPS) ✍️
    :lines: 4
    :language: shell
```
````

Puis, installer le service NTP :

```{literalinclude} snippets/_node-ntp.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 6-7
    :language: shell
```

Et vérifier qu'il est fonctionnel :

```{literalinclude} snippets/_node-ntp.sh
    :caption: ☁️ Serveur (VPS)
    :lines: 9   
    :language: shell
```

````{admonition} Exemple de sortie
    :class: toggle

```{code-block}
Reference ID    : B90D9447 (185.13.148.71)
Stratum         : 3
Ref time (UTC)  : Fri Feb 16 21:37:09 2024
System time     : 0.000273747 seconds fast of NTP time
Last offset     : +0.000051004 seconds
RMS offset      : 0.001002014 seconds
Frequency       : 12.120 ppm fast
Residual freq   : +0.002 ppm
Skew            : 0.183 ppm
Root delay      : 0.012908236 seconds
Root dispersion : 0.000253640 seconds
Update interval : 128.4 seconds
Leap status     : Normal
```
````
