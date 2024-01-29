# Python : Communiquer avec un onduleur WKS EVO Circle via le port série

J'ai dans l'idée de suivre en temps réel la consommation électrique des onduleurs dans un parc photovoltaïque maison.

Niveau matière grise, ce document peut être pour avoir la liste des commandes possibles (toutes ne sont pas prises en compte par l'onduleur, ceci dit) : [HS_MS_MSX RS232 Protocol 20140822|files/hs-ms-msx-communication-protocol-old.pdf] [size=9](PDF &ndash; 185 kio)[/size].

Niveau matériel, il nous faut :

- un onduleur WKS EVO Circle et le câble série fourni
- un adaptateur USB vers série DB9 RS232 - Mâle / Mâle (ICUSB232V2)
- une machine pour exécuter le code Python (PC portable, Rapsberry Pi, etc.)

Pour l'installation :

- raccorder le câble série fourni avec l'adaptateur USB/série
- brancher le câble dans le port **COM** de l'onduleur, puis l'autre côté dans un port USB de la machine

Passons au code, maintenant.

---

Nous aurons besoin du module [pyserial](https://pypi.org/project/pyserial) :

```{code-block} shell
python -m pip install pyserial
```
 
Et très certainement des droits d'accès au port TTY émulé :

```{code-block} shell
sudo gpasswd -a $USER dialout && exit
# or
# sudo chmod a+rw /dev/ttyUSB0
```

Cette fonction établit la connexion avec l'onduleur :

```{code-block} python
import serial

def init_serial(port: str) -> serial.Serial:
    return serial.Serial(
        port=port,
        baudrate=2400,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
    )
```

Celle-ci permet d'envoyer une commande à l'onduleur (comme vu dans le PDF partagé plus haut, une commande est une succession de 3 blocs : `COMMANDE+CRC+CR`, où `COMMANDE` est un mot clef comme par exemple « QID », `CRC` est la somme de contrôle de la commande envoyée, et `CR` est le caractère permettant de dire à l'onduleur que c'est la fin de l'instruction) :

```{code-block} python
def compute_crc(value: str) -> str:
    """
    >>> compute_crc("96332309100452")
    '?xf3'
    """
    crc = 0
    for ch in value:
        if not ch:
            break
        crc ^= ord(ch) << 8
        for _ in range(8):
            crc = crc << 1 if (crc & 0x8000) == 0 else (crc << 1) ^ 0x1021
        crc &= 0xFFFF
    return crc.to_bytes(2, "big").decode(encoding="latin1")


def send_command(conn: serial.Serial, command: str) -> bool:
    full_command = f"{command}{compute_crc(command)}\r"
    return conn.write(serial.to_bytes(ord(c) for c in full_command)) == len(full_command)
```

Enfn, nous pouvons récupérer la réponse de l'onduleur via cette dernière fonction :

```{code-block} python
def get_response(conn: serial.Serial) -> bytes:
    response = conn.read_until(expected=b"\r")

    # Remove leading parenthesis, and trailing CRC + CR
    response = response[1:-3]
    return response.decode(encoding="latin1")
```

---

Exemple d'utilisation avec la récupération du n° de série de l'onduleur :

```{code-block} python
>>> conn = init_serial("/dev/ttyUSB0")
>>> send_command(conn, "QID")
True
>>> serial_number = get_response(conn)
>>> serial_number
'96332309100452'
```

---

J'ai rendu publique le code pour lire les métriques de l'onduleur, car le n° de série est facile à récupérer en comparaison des informations techniques envoyées en bloc, et ça se passe par là : [BoboTiG/python-wks-com](https://github.com/BoboTiG/python-wks-com). Un aperçu :

```{code-block} shell
python -m pip install 'git+https://github.com/BoboTiG/python-wks-com.git@main'
```

```{code-block} python
>>> from inverter_com import Inverter
>>> inverter = Inverter("/dev/ttyUSB0")
>>> inverter.send("QID")
'96332309100452'
```

Et il y a même un exécutable mis à disposition, une fois le module installé :

```{code-block} shell
wks-read --help
wks-read serial-no
```

Toutes les informations utiles se trouvent dans le dépôt GitHub ☺

---

## Historique

- 2024-01-27 : Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2023/12/07/21/34/37-python-communiquer-avec-un-onduleur-wks-evo-circle-via-le-port-serie).
- 2023-12-07 : Premier jet.