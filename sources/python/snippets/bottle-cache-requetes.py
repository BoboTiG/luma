from collections.abc import Callable
from pathlib import Path
from typing import Any

import bottle

CACHE_DIR = Path(__file__).parent / "cache"


def get_from_cache(cache_key: str) -> str | None:
    """Retreive a response from a potential cache file."""
    from contextlib import suppress
    from zlib import decompress

    file = CACHE_DIR / f"{cache_key}.cache"
    with suppress(FileNotFoundError):
        return decompress(file.read_bytes()).decode()
    return None


def store_in_cache(cache_key: str, response: str, *, info: bool = True) -> None:
    """Store a HTTP response into a compressed cache file."""
    from zlib import compress

    if info:
        from datetime import UTC, datetime

        today = datetime.now(tz=UTC)
        response += f"<!-- Cached: {today} -->"

    file = CACHE_DIR / f"{cache_key}.cache"
    file.parent.mkdir(exist_ok=True, parents=True)
    file.write_bytes(compress(response.encode(), level=9))


def invalidate_caches() -> None:
    """Remove all cache files."""
    for file in CACHE_DIR.glob("*.cache"):
        file.unlink(missing_ok=True)


def cache(func: Callable) -> Callable:
    """Decorator used to cache HTTP responses."""
    from functools import wraps

    @wraps(func)
    def wrapper(*args: Any, **kwargs: Any) -> str:
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

    return f"{crc:x}".rjust(8, "0")


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


@bottle.route("/hello/<name>")
def index(name: str) -> str:
    return bottle.template("<b>Hello {{name}}</b>!", name=name)


if __name__ == "__main__":
    bottle.run(host="localhost", port=8080)
