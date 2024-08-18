import re
from functools import partial
from pathlib import Path
from shutil import rmtree
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
    "sphinx-design.min",
    "tabs",
    "custom",
]
JS_FILES = [
    "design-tabs",
    "documentation_options",
    "doctools",
    "sphinx_highlight",
    "clipboard.min",
    "copybutton",
    "togglebutton",
    "language_data",
    "searchtools",
    "tabs",
    "shibuya",
]
ORPHAN_FOLDERS = [
    ".buildinfo",
    ".doctrees",
    "genindex.html",
    "objects.inv",
    "_sources",
    "_sphinx_design_static",
    "_static/base-stemmer.js",
    "_static/basic.css",
    "_static/check-solid.svg",
    "_static/copy-button.svg",
    "_static/copybutton_funcs.js",
    "_static/file.png",
    "_static/french-stemmer.js",
    "_static/minus.png",
    "_static/translations.js",
]


def delete_orphans() -> int:
    total_size = 0

    for path in ORPHAN_FOLDERS:
        full_path = PATH / path
        if full_path.is_dir():
            for file in full_path.glob("*"):
                total_size += file.stat().st_size
            rmtree(full_path)
        else:
            total_size += full_path.stat().st_size
            full_path.unlink(missing_ok=True)
        print(f"Deleted {full_path.parent}/{full_path.name} (-100.00%)", flush=True)

    return total_size


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
    orphan_saved = 0
    minify_saved = 0
    merge_saved = 0
    total_saved = 0

    print(flush=True)

    orphan_saved = delete_orphans()
    total_saved += orphan_saved
    print(f"Saved {orphan_saved / 1024:,.02f} Kio\n", flush=True)

    for file in PATH.glob("**/*"):
        if not file.is_file() or ".min." in file.name or not (minifier := MINIFIER.get(file.suffix)):
            continue

        content = file.read_text()
        minified = minifier(content)
        if content == minified:
            continue

        size_old = len(content)
        size_new = file.write_text(minified)
        minify_saved += size_old - size_new
        diff = 100 - (size_new * 100 / size_old)
        print(f"Minified {file.parent}/{file.name} (-{diff:.2f}%)", flush=True)

    total_saved += minify_saved
    print(f"Saved {minify_saved / 1024:,.02f} Kio\n", flush=True)

    merge_css()
    merge_js()

    for file in PATH.glob("**/*.html"):
        injected_css = False
        injected_js = False
        content = merged = file.read_text()
        size_old = len(content)

        for line, fname in REGEXP_CSS(content):
            if not injected_css:
                path = "/".join(fname.split("/")[:-1])
                final_css = f"<link href={path}/styles.css?v={CURRENT_COMMIT} rel=stylesheet>"
                merged = merged.replace(line, final_css, 1)
                injected_css = True
            else:
                merged = merged.replace(line, "", 1)

        for line, fname in REGEXP_JS(content):
            if not injected_js:
                path = "/".join(fname.split("/")[:-1])
                final_js = f"<script src={path}/scripts.js?v={CURRENT_COMMIT}></script>"
                merged += final_js
                injected_js = True
            merged = merged.replace(line, "", 1)

        size_new = file.write_text(merged)
        diff = 100 - (size_new * 100 / size_old)
        merge_saved += size_old - size_new
        print(f"Merged {file.parent}/{file.name} (-{diff:.2f}%)", flush=True)

    total_saved += merge_saved
    print(f"Saved {merge_saved / 1024:,.02f} Kio\n", flush=True)

    print(f"TOTAL saved {total_saved / 1024:,.02f} Kio", flush=True)


if __name__ == "__main__":
    main()
