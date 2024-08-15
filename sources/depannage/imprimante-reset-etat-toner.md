# Imprimante : Remettre à zéro l'état du toner

Lors du changement de toner, il se peut que l'imprimante garde en mémoire l'état du toner précédent.
Voici la procédure à suivre pour indiquer à l'imprimante qu'un nouveau toner vient d'être installé.

## Brother

### DCP-9055CDN

1. Ouvrir le capot avant ;
2. appuyer sur {kbd}`Effacer` ;
3. dans le menu qui apparaît, sélectionner la cartouche à *reset* et valider.

À savoir que la syntaxe utilisée suit le format `${COULEUR}.TRN-${TYPE}` :

- `${COULEUR}` est une lettre :
  - "K" pour noir ;
  - "C" pour cyan ;
  - "M" pour magenta ;
  - "Y" pour jaune.
- `${TYPE}` peut être :
  - "STD" pour capacité standarde ;
  - "HC" pour grande capacité. 

Exemple pour le noir standard : `K.TRN-STD`.

---

## 📜 Historique

2024-08-15
: Premier jet.
