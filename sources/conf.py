import os
import sys
from datetime import UTC, datetime

from pygments.lexers.web import PhpLexer
from sphinx.highlighting import lexers

lexers["php"] = PhpLexer(startinline=True, linenos=1)

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "."))

author = "Mickaël Schoentgen"
project = "Knowledge Base"
this_year = datetime.now(tz=UTC).year
copyright = f"2006-{this_year}, {author}"  # noqa:A001
url = "https://www.tiger-222.fr"
language = "fr"

extensions = [
    "myst_parser",
    "sphinx_copybutton",
    # "sphinx_design",
    # "sphinx_tabs.tabs",
    "sphinx.ext.todo",
    "sphinx_togglebutton",
]
myst_enable_extensions = [
    "attrs_inline",
    "deflist",
    "replacements",
    "tasklist",
]
todo_include_todos = True
html_theme = "shibuya"
html_css_files = ["custom.css"]
html_static_path = ["_static"]
templates_path = ["_templates"]
source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

html_title = project
html_theme = "shibuya"
html_favicon = "_static/favicon.ico"
html_theme_options = {
    "accent_color": "iris",
    "light_logo": "../_static/favicon.ico",
    "dark_logo": "../_static/favicon.ico",
    "twitter_creator": "__tiger222__",
    "twitter_site": "__tiger222__",
    "twitter_url": "https://twitter.com/__tiger222__",
    "github_url": "https://github.com/BoboTiG",
    "globaltoc_expand_depth": 2,
    "nav_links": [
        {"title": "Blog", "url": url},
        {"title": "Liens", "url": f"{url}/links"},
    ],
}
html_context = {
    "source_type": "github",
    "source_user": "BoboTiG",
    "source_repo": "kb",
    "source_docs_path": "/sources/",
    "source_branch": "main",
}
