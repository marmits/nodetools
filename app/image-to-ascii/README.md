## Installation
- `apt update`
- `apt install graphicsmagick imagemagick`
- `pnpm install`

## Réglages
Si erreur liée à GraphicsMagick lors de l’utilisation de `gm convert` :  
Désactiver l'alias Oh My Zsh 'gm' (git merge) pour laisser GraphicsMagick tranquille
- `/usr/bin/gm\nunalias gm 2>/dev/null || true`

## Running Tests
- `node test.js`
- `node test2.js`

## Doc
Voir [github.com/IonicaBizau/image-to-ascii](https://github.com/IonicaBizau/image-to-ascii)