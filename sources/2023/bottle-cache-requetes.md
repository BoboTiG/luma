# Bottle : Un cache pour les requêtes

[Bottle](https://github.com/bottlepy/bottle) est un framework web écrit en Python.
Nous allons voir comment ajouter un cache à certaines requêtes.

Partons de cet exemple inspiré de la description du projet sur GitHub :

```{code-block} python
    :caption: app.py

import bottle


@bottle.route("/hello/<name>")
def index(name: str) -> str:
    return bottle.template("<b>Hello {{name}}</b>!", name=name)


if __name__ == "__main__":
    bottle.run(host="localhost", port=8080)
```

Démarrons le serveur local :

```{code-block} shell
python app.py
```

Et voyons que ça fonctionne :

```{code-block} shell
curl 'http://localhost:8080/hello/Mickaël'
```
```{code-block} html
    :caption: Sorte de la console

<b>Hello Mickaël</b>
```

---

## Le Cache

L'idée est la suivante : lorsqu'une requête est faite sur `/hello/NAME`, la réponse doit être enregistrée pour un usage ultérieur. La prochaine fois que ce même appel aura lieu, la version en cache sera servie directement.

Le cache en lui-même aura besoin de ces fonctions (c'est une façon de faire, à adapter selon le besoin) :

```{code-block} python
from pathlib import Path

CACHE_DIR = Path(__file__).parent / "cache"


def get_from_cache(cache_key: str) -> str | None:
    """Retreive a response from a potential cache file."""
    from contextlib import suppress
    from zlib import decompress

    file = CACHE_DIR / f"{cache_key}.cache"
    with suppress(FileNotFoundError):
        return decompress(file.read_bytes()).decode()
    return None


def store_in_cache(cache_key: str, response: str, info: bool = True) -> None:
    """Store a HTTP response into a compressed cache file."""
    from zlib import compress

    if info:
        from datetime import datetime, timezone

        today = datetime.now(tz=timezone.utc)
        response += f"<!-- Cached: {today} -->"

    file = CACHE_DIR / f"{cache_key}.cache"
    file.parent.mkdir(exist_ok=True, parents=True)
    file.write_bytes(compress(response.encode(), level=9))
```

Bien sûr, qui dit cache, dit invalidation de cache. Cette fonction sera utile donc :

```{code-block} python
def invalidate_caches() -> None:
    """Remove all cache files."""
    for file in CACHE_DIR.glob("*.cache"):
        file.unlink(missing_ok=True)
```

Et voici le code du cache, qui n'est autre qu'un décorateur :

```{code-block} python
def cache(func):
    """Decorator used to cache HTTP responses."""
    from functools import wraps

    @wraps(func)
    def wrapper(*args, **kwargs) -> str:
        # If Bottle is run in debug mode, then we do not use the cache
        if bottle.DEBUG:
            return func(*args, **kwargs)

        # The cache key is computed from the request path
        cache_key = small_hash(bottle.request.path.lower())
        if (response := get_from_cache(cache_key)) is None:
            response = func(*args, **kwargs)
            store_in_cache(cache_key, response)

        return response

    return wrapper
```

Le clef du cache est déterminée suivant le chemin de la requête (ex : `/hello/Mickaël`) ; il est possible de prendre en compte plus de détails comme les paramètres passés à l'URL, entre autres. Aussi, si Bottle est en mode *debug*, alors le cache est ignoré.

Avec cette information, un hash est généré via la fonction `small_hash()` que voici, inspirée de la [version PHP smallHash() écrite pour Shaarli](https://github.com/sebsauvage/Shaarli/blob/029f75f180f79cd581786baf1b37e810da1adfc3/index.php#L228-L241) (idem, c'est un exemple et libre à chacun de tout chambouler) :

```{code-block} python
def php_crc32(value: str) -> str:
    """
    References:
    - https://www.php.net/manual/en/function.hash-file.php#104836
    - https://stackoverflow.com/a/50843127/636849

        >>> php_crc32("20111006_131924")
        'c991f6df'
        >>> php_crc32("liens.mohja.fr")
        '0c05b1a5'

    """
    crc = 0xFFFFFFFF
    for x in value.encode():
        crc ^= x << 24
        for _ in range(8):
            crc = (crc << 1) ^ 0x04C11DB7 if crc & 0x80000000 else crc << 1
    crc = ~crc
    crc &= 0xFFFFFFFF

    # Convert from big endian to little endian:
    crc = int.from_bytes(crc.to_bytes(4, "big"), byteorder="little")

    return hex(crc)[2:].rjust(8, "0")


def small_hash(value: str) -> str:
    """
    Returns the small hash of a string, using RFC 4648 base64url format
    http://sebsauvage.net/wiki/doku.php?id=php:shaarli

    Small hashes:
    - are unique (well, as unique as crc32, at last)
    - are always 6 characters long
    - only use the following characters: a-z A-Z 0-9 - _ @
    - are NOT cryptographically secure (they CAN be forged)

        >>> small_hash("20111006_131924")
        'yZH23w'

    """
    from base64 import b64encode

    return b64encode(bytes.fromhex(php_crc32(value)), altchars=b"-_").rstrip(b"=").decode()
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

```{code-block} shell
curl 'http://localhost:8080/hello/Mickaël'
```

```{code-block} html
    :caption: Sorte de la console

<b>Hello Mickaël</b>
```

Et les suivants le sont :

```{code-block} shell
curl 'http://localhost:8080/hello/Mickaël'
```

```{code-block} html
    :caption: Sorte de la console

<b>Hello Mickaël</b>
<!-- Cached: 2023-10-17 07:08:41.510318+00:00 -->
```

---

## Historique

- 2024-01-27 : Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2023/10/17/09/02/58-bottle-un-cache-pour-les-requetes).
- 2023-10-17 : Premier jet.