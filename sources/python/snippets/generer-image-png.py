import random
import struct
import zlib
from pathlib import Path


def generate_random_png(filename: str = "", size: int = 0) -> bytes | None:
    """Generate a random PNG file.

    :param filename: The output file name. If None, returns picture content.
    :param size: The number of black pixels of the picture.
    :return mixed: None if given filename else bytes
    """

    size = max(1, size) if size else random.randint(1, 1024)

    pack = struct.pack

    def chunk(header: bytes, data: bytes) -> bytes:
        return pack(">I", len(data)) + header + data + pack(">I", zlib.crc32(header + data) & 0xFFFFFFFF)

    magic = pack(">8B", 137, 80, 78, 71, 13, 10, 26, 10)
    png_filter = pack(">B", 0)
    scanline = pack(f">{size * 3}B", *[0] * (size * 3))
    content = [png_filter + scanline for _ in range(size)]
    png = (
        magic
        + chunk(b"IHDR", pack(">2I5B", size, size, 8, 2, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(b"".join(content)))
        + chunk(b"IEND", b"")
    )

    if filename:
        Path(filename).write_bytes(png)
        return None

    return png


if __name__ == "__main__":
    random_png = generate_random_png()
    generate_random_png("test.png", size=42)
