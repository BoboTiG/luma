# Désactiver l’alarme d’un onduleur Eaton 3S 850

Commandes exécutées sur un système Debian GNU/Linux trixie/sid.

## 🛠️ Installation

Installer `nut` (*Network UPS Tools*) :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 3
:language: shell
```

---

## 🔭 Découverte

Brancher l’onduleur à l’ordinateur, puis démarrer le scanner :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 5
:language: shell
```

````{admonition} Exemple de sortie
:class: toggle

```{code-block}
:emphasize-lines: 10
Cannot load SNMP library (libnetsnmp.so) : file not found. SNMP search disabled.
Cannot load XML library (libneon.so) : file not found. XML search disabled.
Cannot load AVAHI library (libavahi-client.so) : file not found. AVAHI search disabled.
Cannot load IPMI library (libfreeipmi.so) : file not found. IPMI search disabled.
Cannot load NUT library (libupsclient.so) : file not found. NUT search disabled.
Scanning USB bus.
[nutdev1]
    driver = "usbhid-ups"
    port = "auto"
    vendorid = "0463"
    productid = "FFFF"
    product = "Eaton 3S"
    serial = "Blank"
    vendor = "EATON"
    bus = "003"
    device = "008"
    busport = "007"
    ###NOTMATCHED-YET###bcdDevice = "0100"
```
````

---

## ⚙️ Configuration

Configurer `nut` en mode utilitaire :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 7
:language: shell
```

Le fait est que `nut` fonctionne en mode client-serveur, malgré le fait que nous ne l’utilisions qu’en mode simple utilitaire ; il faut donc définir un utilisateur qui pourra modifier les paramètres de l’onduleur :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 17-22
:language: shell
```

Maintenant, ajouter l’onduleur au fichier de configuration de `nut` (adapter la ligne surlignée) :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 9-15
:emphasize-lines: 6
:language: shell
```

Enfin, redémarrer le service :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 24
:language: shell
```

---

## 👀 État de l’Alarme

La commande permettant de connaître l’état de l’alarme est la suivante :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 26
:language: shell
```

Si l’alarme est **activée**, la sortie affichera :

```{code-block}
:emphasize-lines: 2
Init SSL without certificate database
enabled
```

Et lorsqu’elle est **désactivée** :

```{code-block}
:emphasize-lines: 2
Init SSL without certificate database
disabled
```

`````{tip}
La commande `upsc eaton` affichera toutes les caractéristiques de l’onduleur.

````{admonition} Exemple de sortie
:class: toggle

```{code-block} ini
Init SSL without certificate database
battery.charge: 89
battery.charge.low: 20
battery.runtime: 4699
battery.type: PbAc
device.mfr: EATON
device.model: Eaton 3S 850 
device.serial: Blank
device.type: ups
driver.debug: 0
driver.flag.allow_killpower: 0
driver.name: usbhid-ups
driver.parameter.pollfreq: 30
driver.parameter.pollinterval: 2
driver.parameter.port: auto
driver.parameter.synchronous: auto
driver.parameter.vendorid: 0463
driver.state: quiet
driver.version: 2.8.1
driver.version.data: MGE HID 1.46
driver.version.internal: 0.52
driver.version.usb: libusb-1.0.27 (API: 0x100010a)
input.transfer.high: 264
input.transfer.low: 184
outlet.1.desc: PowerShare Outlet 1
outlet.1.id: 1
outlet.1.status: on
outlet.1.switchable: no
outlet.desc: Main Outlet
outlet.id: 0
outlet.switchable: yes
output.frequency.nominal: 50
output.voltage: 230.0
output.voltage.nominal: 230
ups.beeper.status: enabled
ups.delay.shutdown: 20
ups.delay.start: 30
ups.firmware: 02.08.0010
ups.load: 0
ups.mfr: EATON
ups.model: Eaton 3S 850 
ups.power.nominal: 850
ups.productid: ffff
ups.realpower: 0
ups.serial: Blank
ups.status: OB
ups.timer.shutdown: -1
ups.timer.start: -1
ups.type: offline / line interactive
ups.vendorid: 0463
```
`````

---

## 🔕 Désactiver l’Alarme

La commande utilise les informations de l’utilisateur crée en amont :

```{literalinclude} snippets/desactiver-alarme-onduleur-eaton-3s-850.sh
:lines: 30
:language: shell
```

La sortie devrait afficher *OK*.

Vérifier l’[état de l’alarme](#etat-de-lalarme), c’est terminé !

---

## 📜 Historique

2024-12-27
: Premier jet.
