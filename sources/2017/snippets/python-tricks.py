import re
from timeit import repeat


def trick_format() -> None:
    """
    >>> format(123456789, ",")
    '123,456,789'
    >>> format(123456789, "_")
    '123_456_789'
    >>> f"{123456789:,}"
    '123,456,789'
    >>> f"{123456789:_}"
    '123_456_789'
    """


# pow()
x, y, z = 123456789, 2345678, 17

# Option 1: not efficient at all
res = pow(x, y) % z  # Does not end in more than 1 minute!

# Option 2: here we can talk!
res = pow(x, y, z)  # Instantly

# re.sub
fname = "Ça, c'est un nom de fichier (2).odt"
pattern = re.compile(r'([/:"|*<>?\\])')
fname_sanitized = re.sub(pattern, "-", fname)

setup_1 = """
fname = "Ça, c'est un nom de fichier (2).odt"
"""
stmt_1 = """\
fname.replace('/', '-')\
.replace(':', '-')\
.replace('"', '-')\
.replace('|', '-')\
.replace('*', '-')\
.replace('<', '-')\
.replace('>', '-')\
.replace('?', '-')\
.replace('\\\\', '-')
"""

setup_2 = """
from re import compile, sub
pattern = compile(r'([/:"|*<>?\\\\])')
fname = "Ça, c'est un nom de fichier (2).odt"
"""
stmt_2 = "sub(pattern, '-', fname)"

setup_3 = """
repmap = {ord(c): "-" for c in '/:"|*<>?\\\\'}
fname = "Ça, c'est un nom de fichier (2).odt"
"""
stmt_3 = "fname.translate(repmap)"

print(min(repeat(stmt_1, setup_1, number=100000)))
print(min(repeat(stmt_2, setup_2, number=100000)))
print(min(repeat(stmt_3, setup_3, number=100000)))

# str.startswith() & str.endswith()
text = "azerty"

# Option 1: basic usage, not efficient
if (
    text.startswith("a")  # noqa:PIE810
    or text.startswith("b")
    or text.startswith("c")
    or text.startswith("d")
    or text.startswith("e")
    or text.startswith("f")
):
    pass

# Option 2: best usage, efficient
if text.startswith(("a", "b", "c", "d", "e", "f")):
    pass


def trick_time() -> None:
    """
    >>> import datetime, time
    >>> today = datetime.datetime.now().timetuple()
    >>> time.strftime("%Y-%m-%d", today)
    '2017-12-06'
    >>> time.strftime("%Y-%m-%-d", today)  # Check the '%-d'
    '2017-12-6'
    """
