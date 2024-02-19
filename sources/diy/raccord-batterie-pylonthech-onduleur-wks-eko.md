# Raccord d'une batterie Pylontech vers un onduleur WKS EKO Circle

Un câblage incorrect ou un câble défectueux peuvent mener à voir une `Erreur 61` sur l'écran de l'onduleur. Il s'agit du code d'erreur spécifiant que la **liaison avec la batterie est perdue**.

---

## Liaison

Pour que l'onduleur ([WKS EKO Circle](https://www.wattuneed.com/fr/onduleurs-et-convertisseurs/25678-onduleur-hybride-wks-evo-56kva-48v-0768563819193.html)) puisse communiquer avec la ou les batteries ([Pylontech US5000](https://en.pylontech.com.cn/products/c23/134.html)), nous modifierons un [câble RJ45](images/rj45.svg).

Ci-dessous, le schéma d'installation concentré sur la connexion ([cliquer ici pour télécharger le schéma complet](images/schema-communication-onduleur-wks-eko-circle-vers-batterie-pylontech-complet.jpg)) :

```{figure} images/schema-communication-onduleur-wks-circle-vers-batterie-pylontech-zoom.jpg
  :align: center
```

### Côté Onduleur

Sur l'onduleur (*inverter* en anglais), le câble se branche dans le port **BMS**, et il ne comporte que 2 pins : les n° 3 (marron) et 5 (blanc marron) :

```{figure} images/rj45-rs485-inverter.svg
  :align: center
```

```{todo}
Fournir une image adaptée au thème sombre.
```

### Côté Batterie

Sur la batterie (*battery* en anglais), le câble se branche dans le port **B/RS485**, et il ne comporte que 2 pins : les n° 7 (blanc marron) et 8 (marron) :

```{figure} images/rj45-rs485-battery.svg
  :align: center
```

```{tip}
De ce côté-là, il est possible de laisser un câble RJ45 d'origine avec les 8 pins.
```

```{todo}
Fournir une image adaptée au thème sombre.
```

---

#### DIP

Dernier point, sur la batterie *master*, bien vérifier que les DIP 4, 3 et 2 sont en position haute (OFF), et 1 en position basse (ON) :

```{figure} images/battery-pylontech-dip-master.svg
  :align: center
```

Si batterie(s) *slave* il y a, mettre tous leurs DIP en position haute (OFF) :

```{figure} images/battery-pylontech-dip-slave.svg
  :align: center
```

---

## 🎣 Sources

- [File:RJ-45 TIA-568A Left.svg](https://commons.wikimedia.org/wiki/File:RJ-45_TIA-568A_Left.svg) ;
- [Wattuneed : Schémas de montage photo-voltaïque](https://www.wattuneed.com/fr/content/28-schema-de-montage-photovoltaique) ;
- Les fichiers SVG sont libres de droits.

## 🧰 Matériel

- [Pince à sertir RJ45 (VCELINK GJ671BL)](https://www.amazon.fr/dp/B08NX12GJ5) ;
- [Pince coupante de précision (VCELINK)](https://www.amazon.fr/dp/B09SL2TCH7) ;
- [Connecteurs RJ45](https://www.amazon.fr/dp/B0857FL8G6).

## 📜 Historique

2024-01-27
: Déplacement de l'article depuis le [blog](https://www.tiger-222.fr/?d=2023/12/16/23/12/04-raccord-dune-batterie-pylontech-vers-un-onduleur-wks-eko-circle).

2023-12-16
: Premier jet.
