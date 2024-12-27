# Python : Communiquer avec un onduleur WKS EVO Circle via le port série

## 🧰 Matériel

- un onduleur WKS EVO Circle et le câble série fourni
- un adaptateur USB vers série DB9 RS232 - Mâle / Mâle (ICUSB232V2)
- une machine pour exécuter le code Python (PC portable, Raspberry Pi, etc.)
- le fichier PDF technique : [HS-MS-MSX RS232 Protocol 20240822](../_static/hs-ms-msx-communication-protocol-old.pdf)

## Installation

- raccorder le câble série fourni avec l’adaptateur USB/série
- brancher le câble dans le port **COM** de l’onduleur, puis l’autre côté dans un port USB de la machine

## Code

Nous aurons besoin du module [pyserial](https://pypi.org/project/pyserial) :

```{code-block} shell
python -m pip install pyserial
```

Et très certainement des droits d’accès au port TTY émulé :

```{code-block} shell
sudo gpasswd -a $USER dialout && exit
# or
# sudo chmod a+rw /dev/ttyUSB0
```

Cette fonction établit la connexion avec l’onduleur :

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:lines: 1-11
:language: python
```

Celle-ci permet d’envoyer une commande à l’onduleur (comme vu dans le PDF partagé plus haut, une commande est une succession de 3 blocs : `COMMANDE+CRC+CR`, où `COMMANDE` est un mot clé comme « QID », `CRC` est la somme de contrôle de la commande envoyée, et `CR` est le caractère permettant de dire à l’onduleur que c’est la fin de l’instruction) :

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:pyobject: send_command
:language: python
```

Pour calculer la somme de contrôle :

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:pyobject: compute_crc
:language: python
```

Enfin, nous pouvons récupérer la réponse de l’onduleur via cette dernière fonction :

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:pyobject: get_response
:language: python
```

### Exemple

Exemple d’utilisation avec la récupération du n° de série de l’onduleur :

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:lines: 45-49
:dedent:
:language: python
```

## Module Spécifique

J’ai rendu publique le code pour lire les métriques de l’onduleur, car le n° de série est facile à récupérer en comparaison des informations techniques envoyées en bloc, et ça se passe par là : [BoboTiG/python-wks-com](https://github.com/BoboTiG/python-wks-com). Un aperçu :

```{code-block} shell
python -m pip install -U wks-com
```

```{literalinclude} snippets/communication-onduleur-wks-eko.py
:lines: 55-58
:dedent:
:language: python
```

Et il y a même un exécutable mis à disposition, une fois le module installé :

```{code-block} shell
wks-read --help
wks-read serial-no
```

Toutes les informations utiles se trouvent dans le dépôt GitHub ☺

---

## 📜 Historique

2024-12-27
: Ajout du fichier PDF contenant les informations techniques.

2024-11-02
: Le module Python WKS COM étant maintenant disponible sur PyPI, mise à jour du code d’installation.

2024-10-26
: Mise à jour du module Python WKS COM (`1.0.1` → `1.2.0`).

2024-01-27
: Déplacement de l’article depuis le [blog](https://www.tiger-222.fr/?d=2023/12/07/21/34/37-python-communiquer-avec-un-onduleur-wks-evo-circle-via-le-port-serie).

2023-12-07
: Premier jet.
