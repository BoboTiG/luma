# Bottle : Un cache pour les requêtes

[Bottle](https://github.com/bottlepy/bottle) est un framework web écrit en Python.
Nous allons voir comment ajouter un cache à certaines requêtes.

Partons de cet exemple inspiré de la description du projet sur GitHub :

```{literalinclude} snippets/bottle-cache-requetes.py
    :caption: app.py
    :lines: 6,108-116
    :language: python
```

Démarrons le serveur local :

```{code-block} shell
python app.py
```

Et voyons que ça fonctionne :

```{code-block} html
    :caption: $ curl 'http://localhost:8080/hello/Mickaël'

<b>Hello Mickaël</b>
```

---

## Le Cache

L'idée est la suivante : lorsqu'une requête est faite sur `/hello/NAME`, la réponse doit être enregistrée pour un usage ultérieur. La prochaine fois que ce même appel aura lieu, la version en cache sera servie directement.

Le cache en lui-même aura besoin de ces fonctions (c'est une façon de faire, à adapter selon le besoin) :

```{literalinclude} snippets/bottle-cache-requetes.py
    :caption: Imports & constante
    :lines: 1-4,7-8
```

```{literalinclude} snippets/bottle-cache-requetes.py
    :lines: 1-4,7-8
  :pyobject: get_from_cache
    :language: python
```

```{literalinclude} snippets/bottle-cache-requetes.py
  :pyobject: store_in_cache
    :language: python
```

Bien sûr, qui dit cache, dit invalidation de cache. Cette fonction sera utile donc :

```{literalinclude} snippets/bottle-cache-requetes.py
  :pyobject: invalidate_caches
    :language: python
```

Et voici le code du cache, qui n'est autre qu'un décorateur :

```{literalinclude} snippets/bottle-cache-requetes.py
  :pyobject: cache
    :language: python
```

Le clef du cache est déterminée suivant le chemin de la requête (ex : `/hello/Mickaël`) ; il est possible de prendre en compte plus de détails comme les paramètres passés à l'URL, entre autres. Aussi, si Bottle est en mode *debug*, alors le cache est ignoré.

Avec cette information, un hash est généré via la fonction `small_hash()` que voici, inspirée de la [version PHP smallHash() écrite pour Shaarli](https://github.com/sebsauvage/Shaarli/blob/029f75f180f79cd581786baf1b37e810da1adfc3/index.php#L228-L241) (idem, c'est un exemple et libre à chacun de tout chambouler) :

```{literalinclude} snippets/bottle-cache-requetes.py
  :pyobject: php_crc32
    :language: python
```

```{literalinclude} snippets/bottle-cache-requetes.py
  :pyobject: small_hash
    :language: python
```

Dernière étape, utiliser le décorateur :

```{code-block} diff
 @bottle.route("/hello/<name>")
+@cache
 def index(name: str) -> str:
     return bottle.template("<b>Hello {{name}}</b>!", name=name)
```

---

## Résultat

Le premier appel n'est pas en cache :

```{code-block} html
    :caption: $ curl 'http://localhost:8080/hello/Mickaël'

<b>Hello Mickaël</b>
```

Et les suivants le sont :

```{code-block} html
    :caption: $ curl 'http://localhost:8080/hello/Mickaël'

<b>Hello Mickaël</b>
<!-- Cached: 2023-10-17 07:08:41.510318+00:00 -->
```

---

## Historique

- 2024-01-27 : Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2023/10/17/09/02/58-bottle-un-cache-pour-les-requetes).
- 2023-10-17 : Premier jet.
