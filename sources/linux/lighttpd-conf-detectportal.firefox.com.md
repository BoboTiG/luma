# Configuration Lighttpd pour contenir le trafic vers detectportal.firefox.com

Voici une configuration pour [Lighttpd](https://www.lighttpd.net) couplée à [Pi-hole](https://pi-hole.net) afin de prévenir tout accès à ce domaine, tout en faisant croire aux appareils que la connexion est bien établie.

## Pré-requis

Du côté du système, nous aurons besoin d’installer ce paquet :

```{code-block} shell
sudo apt install lighttpd-modules-lua
```

## Configuration

### Lighttpd

Nous utiliserons le [mod magnet](https://redmine.lighttpd.net/projects/lighttpd/wiki/Mod_magnet) pour arriver à nos fins.

Configurons un nouveau site web :

```{code-block} shell
:caption: /etc/lighttpd/conf-available/16-detectportal.conf

$HTTP["host"] == "detectportal.firefox.com" {
    magnet.attract-raw-url-to = ( "/etc/lighttpd/scripts/200-success.lua" )
}
server.modules += ( "mod_magnet" )
```

Il va falloir activer ce nouveau site web, puis créer le dossier pour stocker le script Lua qui contiendra la logique de traitement de la requête :

```{code-block} shell
sudo ln -s \
    /etc/lighttpd/conf-available/16-detectportal.conf \
    /etc/lighttpd/conf-enabled/16-detectportal.conf \
    && sudo mkdir -p /etc/lighttpd/scripts
```

Le script Lua en question :

```{code-block} lua
:caption: /etc/lighttpd/scripts/200-success.lua

lighty.r.resp_body.set({'success\n'})
lighty.r.resp_header["Content-Type"] = "text/html"
return 200
```

Enfin, relancer Lighttpd :

```{code-block} shell
sudo systemctl restart lighttpd
```

### Pi-hole

- Rendez-vous dans le menu « Local DNS » / « DNS Records » ;
- Ajouter le domaine `detectportal.firefox.com` avec l'adresse IP de Pi-hole (par exemple `192.168.2.12`) ;
- Cliquer sur « Add ».

## Test

Exemple de sortie console lorsque tout est correctement en place :

```{code-block} text
:caption: $ curl -v detectportal.firefox.com

* Host detectportal.firefox.com:80 was resolved.
* IPv6: 2600:1901:0:38d7::
* IPv4: 192.168.2.12
*   Trying 192.168.2.12:80...
* Connected to detectportal.firefox.com (192.168.2.12) port 80
> GET / HTTP/1.1
> Host: detectportal.firefox.com
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< Content-Type: text/html
< Accept-Ranges: bytes
< Content-Length: 8
< Date: Tue, 09 Jan 2024 18:39:58 GMT
< Server: lighttpd/1.4.69
< 
success
* Connection #0 to host detectportal.firefox.com left intact
```

---

## 📜 Historique

2024-01-27
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2024/01/09/18/34/35-configuration-lighttpd-pour-contenir-le-trafic-vers-detectportalfirefoxcom).

2024-01-09
: Premier jet.
