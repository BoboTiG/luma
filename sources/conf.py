import sys
from datetime import UTC, datetime
from pathlib import Path
from zoneinfo import ZoneInfo

from pygments.lexers.web import PhpLexer
from sphinx.highlighting import lexers

lexers["php"] = PhpLexer(startinline=True, linenos=1)

sys.path.insert(0, f"{Path(__file__).parent}.")

author = "Mickaël Schoentgen"
project = "Base de connaissances du luma"
this_year = datetime.now(tz=UTC).year
copyright = f"2023-{this_year}, {author}"  # noqa:A001
url = "https://www.tiger-222.fr"
language = "fr"

extensions = [
    "myst_parser",
    "notfound.extension",
    "sphinx_contributors",
    "sphinx_copybutton",
    "sphinx_design",
    "sphinx.ext.intersphinx",
    "sphinx.ext.todo",
    "sphinx_last_updated_by_git",
    "sphinx_reredirects",
    "sphinx_tabs.tabs",
    "sphinx_togglebutton",
]
myst_enable_extensions = [
    "attrs_inline",
    "deflist",
    "replacements",
    "tasklist",
]
myst_links_external_new_tab = True
suppress_warnings = ["myst.xref_missing"]
todo_include_todos = True
html_theme = "shibuya"
html_css_files = ["custom.css"]
html_static_path = ["_static"]
templates_path = ["_templates"]
source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}
intersphinx_mapping = {
    "python": ("https://docs.python.org/3", None),
}
togglebutton_hint = "Cliquer pour afficher"
togglebutton_hint_hide = "Cliquer pour cacher"

html_title = project
html_theme = "shibuya"
html_favicon = "_static/favicon.svg"
html_logo = "_static/logo.svg"
html_theme_options = {
    "accent_color": "iris",
    "page_layout": "compact",
    "twitter_creator": "__tiger222__",
    "twitter_site": "__tiger222__",
    "twitter_url": "https://twitter.com/__tiger222__",
    "github_url": "https://github.com/BoboTiG",
    "globaltoc_expand_depth": 2,
    "nav_links": [
        {"title": "🏠 Blog", "url": url},
        {"title": "🔗 Liens", "url": f"{url}/links"},
        {"title": "🎖️ Patreon", "url": "https://www.patreon.com/mschoentgen"},
    ],
}
html_context = {
    "languages": [
        ("Français", "/" if "_live" in sys.argv else f"{url}/luma/"),
        ("English", "/en/" if "_live" in sys.argv else f"{url}/luma/en/"),
    ],
    "source_type": "github",
    "source_user": "BoboTiG",
    "source_repo": "luma",
    "source_docs_path": "/sources/",
}
html_copy_source = False

# Do not include shared files
exclude_patterns = ["**/_*"]

# Do not include drafts when deploying to production
if "_live" not in sys.argv:
    exclude_patterns.append("brouillons/**")

# sphinx-copybutton (content to be skipped when copying)
#   - .linenos is the Sphinx default for line numbers
#   - .gp is the Pygments class for the prompts
#   - .go is the class for console outputs
copybutton_exclude = ".linenos, .gp, .go"

# sphinx-last-updated-by-git
git_last_updated_timezone = ZoneInfo("Europe/Paris")
html_last_updated_fmt = "%Y-%m-%d %H:%M:%S UTC%Z"

# sphinx-notfound-page
notfound_context = {
    "title": "Elle est où la page ?",
    "body": '<h1><a href="https://www.youtube.com/watch?v=wV4wepiucf4" target="_blank">Elle est où la page ?</a></h1><p>¯\\_(ツ)_/¯</p><p>La page en question ne semble pas, ou plus, exister.</p>',  # noqa: E501
}
notfound_urls_prefix = None

# Redirections of old pages
redirects = {
    # 2024-12-17
    "dev/mise-a-jour-router-tenda-ac18.html": "../reseau/mise-a-jour-routeur-tenda-ac18.html",
    "dev/mise-a-jour-routeur-tenda-ac18.html": "../reseau/mise-a-jour-routeur-tenda-ac18.html",
}
