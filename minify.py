import re
from functools import partial
from pathlib import Path
from subprocess import check_output

import minify_html
import rcssmin
import rjsmin

PATH = Path("luma")
STATIC = PATH / "_static"
MINIFIER = {
    ".css": rcssmin.cssmin,
    ".js": rjsmin.jsmin,
    ".html": partial(minify_html.minify, minify_css=True, minify_js=True),
}
REGEXP_CSS = re.compile(r"(<link href=([^ ]+)(?: media=print)? rel=stylesheet>)").findall
REGEXP_JS = re.compile(r"(<script src=([^>]+)></script>)").findall
CURRENT_COMMIT = check_output(["git", "rev-parse", "HEAD"], text=True)[:8]
CSS_FILES = [
    "pygments",
    "shibuya",
    "copybutton",
    "togglebutton",
    "sphinx_contributors",
    "custom",
]
JS_FILES = [
    "documentation_options",
    "doctools",
    "sphinx_highlight",
    "clipboard.min",
    "copybutton",
    "togglebutton",
    "language_data",
    "searchtools",
    "shibuya",
]


def merge_css() -> None:
    merged = ""
    for stem in CSS_FILES:
        file = STATIC / f"{stem}.css"
        merged += f"/*{file.name}*/{file.read_text()}\n"
        file.unlink()

    file = STATIC / "print.css"
    merged += f"/*{file.name}*/@media print{{{file.read_text()}}}\n"
    file.unlink()

    (STATIC / "styles.css").write_text(merged)


def merge_js() -> None:
    merged = ""
    for stem in JS_FILES:
        file = STATIC / f"{stem}.js"
        merged += f"/*{file.name}*/{file.read_text()}\n"
        file.unlink()
    (STATIC / "scripts.js").write_text(merged)


def main() -> None:
    total_saved = 0

    for file in PATH.glob("**/*"):
        if not file.is_file() or ".min." in file.name or not (minifier := MINIFIER.get(file.suffix)):
            continue

        content = file.read_text()
        minified = minifier(content)
        if content == minified:
            continue

        size_old = len(content)
        size_new = file.write_text(minified)
        total_saved += size_old - size_new
        diff = 100 - (size_new * 100 / size_old)
        print(f"Minified {file.name} (-{diff:.2f}%)", flush=True)

    print(f"Saved {total_saved:,} bytes", flush=True)

    merge_css()
    merge_js()

    for file in PATH.glob("**/*.html"):
        injected_css = False
        injected_js = False
        content = merged = file.read_text()
        size_old = len(content)

        for line, fname in REGEXP_CSS(content):
            if not injected_css:
                path = "/".join(p for p in fname.split("/")[:-1])
                final_css = f"<link href={path}/styles.css?v={CURRENT_COMMIT} rel=stylesheet>"
                merged = merged.replace(line, final_css, 1)
                injected_css = True
            else:
                merged = merged.replace(line, "", 1)

        for line, fname in REGEXP_JS(content):
            if not injected_js:
                path = "/".join(p for p in fname.split("/")[:-1])
                final_js = f"<script src={path}/scripts.js?v={CURRENT_COMMIT}></script>"
                merged += final_js
                injected_js = True
            merged = merged.replace(line, "", 1)

        size_new = file.write_text(merged)
        diff = 100 - (size_new * 100 / size_old)
        total_saved += size_old - size_new
        print(f"Merged {file.name} (-{diff:.2f}%)", flush=True)

    print(f"Saved {total_saved:,} bytes", flush=True)


if __name__ == "__main__":
    main()
