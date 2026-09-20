# Imprimante : Remettre à zéro l’état du toner

Lors du changement de toner, il se peut que l’imprimante garde en mémoire l’état du toner précédent.
Voici la procédure à suivre pour lui indiquer qu’un nouveau toner vient d’être installé.

## Brother

### DCP-9055CDN

1. Ouvrir le capot avant ;
2. appuyer sur {kbd}`Effacer` ;
3. dans le menu qui apparaît, sélectionner la cartouche à *reset* puis valider.

Les choix du menu suivent le format `<COULEUR>.TRN-<TYPE>` :

- `<COULEUR>` est une lettre :
  - "C" pour cyan ;
  - "K" pour noir ;
  - "M" pour magenta ;
  - "Y" pour jaune.
- `<TYPE>` peut être :
  - "HC" pour grande capacité ;
  - "STD" pour capacité standarde.

Exemple pour le toner noir standard : `K.TRN-STD`.

### MFC-L2710DW

1. Ouvrir le capot avant ;
2. tout en restant appuyé sur {kbd}`Effacer`, appuyer sur {kbd}`Arrêt/Sortie` ;
3. relâcher {kbd}`Arrêt/Sortie` puis {kbd}`Effacer` ;
4. rappuyer une fois sur {kbd}`Effacer` ;
5. dans le menu qui apparaît, sélectionner `K.TNR-HC` puis valider en appuyant sur {kbd}`OK` ;
6. appuyer sur le bouton de sélection pour aller vers le haut pour confirmer le *reset*, valider en appuyant sur {kbd}`OK` pour terminer ;
7. refermer le capot.

## 📜 Historique

2026-09-20
: Ajout de l'imprimante [Brother MFC-L2710DW](#mfc-l2710dw).

2024-08-15
: Premier jet.
