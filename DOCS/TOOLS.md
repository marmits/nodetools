## ✔️ **Manipulation JSON rapide** (`jq`)

Exemples :

*   Extraire la version :
    ```bash
    jq -r .version package.json
    ```
*   Modifier un champ JSON :
    ```bash
    jq '.dependencies' package.json
    ```
Super utile avec npm/pnpm/yarn.

***

## ✔️ **Recherche instantanée dans ton code** (`ripgrep`)

Exemples :

```bash
rg "TODO"
rg "function setup"
rg "console.log"
```

Beaucoup plus rapide et pratique que `grep`.

***

## ✔️ **Navigation intelligente** (`fzf`)

Tu peux :

*   chercher un fichier instantanément
*   explorer l’historique de commandes
*   combiner avec `rg`

Exemple :

```bash
rg "jwt" | fzf
```

***

## ✔️ **Node-gyp ready** (build-essential + python3)

Indispensable pour tous les packages npm avec modules natifs.

***

## ✔️ **Zsh agréable (mais léger)**

Avec autosuggestions + syntax highlighting.  
Tu peux toujours utiliser `bash` si tu préfères.

***