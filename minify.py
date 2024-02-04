from functools import partial
from pathlib import Path

import minify_html
import rcssmin
import rjsmin

MINIFIER = {
    ".css": rcssmin.cssmin,
    ".js": rjsmin.jsmin,
    ".html": partial(minify_html.minify, minify_css=True, minify_js=True),
}


def main(folder: str) -> None:
    total_saved = 0

    for file in Path(folder).glob("**/*"):
        if not file.is_file() or not (minifier := MINIFIER.get(file.suffix)):
            continue

        content = file.read_text()
        minified = minifier(content)
        if content == minified:
            continue

        file.write_text(minified)
        size_old = len(content)
        size_new = len(minified)
        total_saved += size_old - size_new
        diff = 100 - (size_new * 100 / size_old)
        print(f"Minified {file.name} (-{diff:.2f}%)", flush=True)

    print(f"Saved {total_saved:,} bytes", flush=True)


if __name__ == "__main__":
    import sys

    main(sys.argv[1])
