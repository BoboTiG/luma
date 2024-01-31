# Configuration Lighttpd pour contenir le trafic vers connectivitycheck.gstatic.com

Tous les smartphones Android vont taper sur *connectivitycheck.gstatic.com* pour savoir si la connexion Wi-Fi est bien établie. Comme je n'ai pas besoin de cette information, et que le nombre de requêtes est ahurissant, voici une configuration pour [Lighttpd](https://www.lighttpd.net) et [Pi-hole](https://pi-hole.net) afin de prévenir tout accès à ce domaine, tout en faisant croire aux appareils que la connexion est bien établie.

## Pré-requis

Du côté du système, nous aurons besoin d'installer ce paquet :

```{code-block} shell
sudo apt install lighttpd-modules-lua
```

## Configuration

### Lighttpd

Du côté de Lighttpd, nous utiliserons le [mod magnet](https://redmine.lighttpd.net/projects/lighttpd/wiki/Mod_magnet) pour arriver à nos fins.

Configurons un nouveau site web :

```{code-block} shell
    :caption: /etc/lighttpd/conf-available/16-connectivitycheck.conf

$HTTP["host"] == "connectivitycheck.gstatic.com" {
    $HTTP["url"] == "/generate_204" {
        magnet.attract-raw-url-to = ( "/etc/lighttpd/scripts/204.lua" )
    } else {
        magnet.attract-raw-url-to = ( "/etc/lighttpd/scripts/404.lua" )
    }
}
server.modules += ( "mod_magnet" )
```

Pour terminer, il va falloir activer ce nouveau site web, puis créer d'autres fichiers contenant les réponses HTTP :

```{code-block} shell
sudo ln -s \
    /etc/lighttpd/conf-available/16-connectivitycheck.conf \
    /etc/lighttpd/conf-enabled/16-connectivitycheck.conf \
    && sudo mkdir -p /etc/lighttpd/scripts \
    && sudo echo 'return 204\n' > /etc/lighttpd/scripts/204.lua \
    && sudo echo 'return 404\n' > /etc/lighttpd/scripts/404.lua \
    && sudo systemctl restart lighttpd
```

### Pi-hole

- Rendez-vous dans le menu « Local DNS » / « DNS Records » ;
- Ajouter le domaine `connectivitycheck.gstatic.com` avec l'adresse IP de Pi-hole (par exemple `192.168.2.12`) ;
- Cliquer sur « Add ».

## Test

Exemple de sortie console lorsque tout est correctement en place :

```{code-block} text
    :caption: $ curl -v connectivitycheck.gstatic.com/generate_204

* Host connectivitycheck.gstatic.com:80 was resolved.
* IPv6: 2a00:1450:4007:80d::2003
* IPv4: 192.168.2.12
*   Trying 192.168.2.12:80...
* Connected to connectivitycheck.gstatic.com (192.168.2.12) port 80
> GET /generate_204 HTTP/1.1
> Host: connectivitycheck.gstatic.com
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 204 No Content
< Date: Tue, 09 Jan 2024 09:59:18 GMT
< Server: lighttpd/1.4.69
< 
* Connection #0 to host connectivitycheck.gstatic.com left intact
```

---

## Historique

2024-01-27
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2024/01/09/09/59/17-configuration-lighttpd-pour-contenir-le-trafic-vers-connectivitycheckgstaticcom).

2024-01-09
: Premier jet.
