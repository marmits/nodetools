## Utilisation du theme en LOCAL / VCS
***
[![NodeJs Version](https://img.shields.io/npm/v/node?label=node)](https://nodejs.org/fr/blog/release/v24.12.0)    
[![](https://img.shields.io/github/v/release/rbardini/resumed?label=rbardini/resumed)](https://github.com/rbardini/resumed)  
[![](https://img.shields.io/github/package-json/v/marmits/jsonresume-theme-stackoverflowmar?label=jsonresume-theme-stackoverflowmar)](https://github.com/marmits/jsonresume-theme-stackoverflowmar)  
[![NPM Version](https://img.shields.io/npm/v/puppeteer?label=puppeteer)](https://www.npmjs.com/package/puppeteer)

## Prérequis
Dans le répertoire de l'hôte `app/cvmarmits/` (workspace pnpm), clone du thème JSON Resume **stackoverflowmar**:
Install en local du theme JSON Resume **stackovermar** dans un workspace pnpm avec l’app **jsonresume**.
- `git clone https://github.com/marmits/jsonresume-theme-stackoverflowmar.git`

## 1) `pnpm-workspace.yaml` (dans `/app/cvmarmits/`)

```yaml
packages:
  - "jsonresume"
  - "jsonresume-theme-stackoverflowmar"
```

> Ce fichier déclare que les deux dossiers font partie du **même workspace pnpm**.

***

## 2) `package.json` (root du workspace `/app/cvmarmits/package.json`)

```json
{
  "private": true,
  "name": "cvmarmits-workspace",
  "version": "0.0.0",
  "pnpm": {
    "link-workspace-packages": true,
    "overrides": {
      "jsonresume-theme-stackoverflowmar": "workspace:*"
    }
  }
}
```

*   `link-workspace-packages: true` → pnpm crée des **symlinks** entre paquets du workspace.
*   `overrides` → **force l’usage du thème local** (utile en dev).  
    En **prod/CI**, tu pourras retirer cet override (voir section “Basculer local ↔ VCS”).

***

## 3) `package.json` de l’app (`/app/cvmarmits/jsonresume/package.json`)

```json
{
  "private": true,
  "type": "module",
  "scripts": {
    "init": "resumed init",
    "resumed": "resumed init",
    "pdf": "node pdfResume.js",
    "test": "echo \"No tests specified\" && exit 0"
  },
  "dependencies": {
    "jsonresume-theme-stackoverflowmar": "workspace:*",
    "puppeteer": "^24.34.0",
    "resumed": "^6.1.0"
  },
  "name": "jsonresumemarmits",
  "version": "2.0.0",
  "main": "pdfResume.js",
  "author": "marmits.com",
  "license": "ISC",
  "description": "Build JSON Resume HTML/PDF with StackOverflowMar theme"
}
```

> Avec `workspace:*`, l’app utilise **automatiquement le thème local** du workspace.  
> Ton `pnpm list` montre bien `link:../jsonresume-theme-stackoverflowmar` → ✅

***

## 4) `package.json` du thème (`/app/cvmarmits/jsonresume-theme-stackoverflowmar/package.json`)

```json
{
  "name": "jsonresume-theme-stackoverflowmar",
  "version": "2.0.1",
  "description": "Stack Overflow theme for JSON Resume for Marmits => FR",
  "author": "marmits",
  "repository": {
    "type": "git",
    "url": "https://github.com/marmits/jsonresume-theme-stackoverflowmar"
  },
  "license": "MIT",
  "type": "module",
  "main": "index.js",
  "files": ["index.js", "resume.hbs", "style.css", "theme/"],
  "scripts": {
    "build": "echo \"Pas de build\"",
    "prepare": "pnpm run build"
  },
  "dependencies": {
    "handlebars": "^4.7.7",
    "markdown-it": "^13.0.1",
    "moment": "^2.29.2"
  }
}
```

> `files` (optionnel) utile si tu publies.  
> Si tu ajoutes un build réel (TS/Bundling), remplace `"build"` par ta commande.

***

## 5) Commandes (README)

### Installation (workspace)

```bash
cd /app/cvmarmits
pnpm install
```

### Initialiser le CV (génère `resume.json`)

```bash
cd /app/cvmarmits/jsonresume
pnpm run init
```

### Rendu HTML (CLI)

```bash
pnpm exec resumed render resume.json --theme jsonresume-theme-stackoverflowmar
# (fallback si nécessaire)
pnpm exec resumed render resume.json --theme ../jsonresume-theme-stackoverflowmar
```

### Générer le PDF (script Node)

```bash
pnpm run pdf
```

> Si pnpm bloque les scripts Puppeteer (message “Ignored build scripts”), autorise-les :
>
> ```bash
> cd /app/cvmarmits
> pnpm approve-builds
> # ou
> pnpm config set allow-scripts true --location project
> pnpm install
> ```

***

## 6) Basculer **thème local ↔ thème VCS (GitHub)**

### Mode **DEV (local)**

*   Garde l’override au root (`/app/cvmarmits/package.json`) :
    ```json
    "pnpm": {
      "link-workspace-packages": true,
      "overrides": {
        "jsonresume-theme-stackoverflowmar": "workspace:*"
      }
    }
    ```
*   Dans l’app :
    ```json
    "jsonresume-theme-stackoverflowmar": "workspace:*"
    ```

➡️ `pnpm list` montre :  
`jsonresume-theme-stackoverflowmar link:../jsonresume-theme-stackoverflowmar` → ✅

### Mode **PROD/CI (VCS/GitHub)**

1.  **Retire l’override** du root (`/app/cvmarmits/package.json`), ou mets-le à vide :
    ```json
    "pnpm": {
      "link-workspace-packages": true,
      "overrides": {}
    }
    ```
2.  Dans l’app (`/app/cvmarmits/jsonresume/package.json`), pointe vers GitHub :
    ```json
    "dependencies": {
      "jsonresume-theme-stackoverflowmar":
        "github:marmits/jsonresume-theme-stackoverflowmar#v2.0.2",
      "puppeteer": "^24.34.0",
      "resumed": "^6.1.0"
    }
    ```
3.  Réinstalle au niveau workspace :
    ```bash
    cd /app/cvmarmits
    pnpm install
    ```

➡️ L’app utilisera la version **VCS**.

***

## 7) Vérifications utiles

*   **Thème local résolu :**
    ```bash
    cd /app/cvmarmits/jsonresume
    pnpm list jsonresume-theme-stackoverflowmar --depth 0
    ```
    Doit afficher `link:jsonresume-theme-stackoverflowmar`.

*   **Symlink dans l’app :**
    ```bash
    ls -l /app/cvmarmits/jsonresume/node_modules/jsonresume-theme-stackoverflowmar
    ```
    Doit pointer vers `../../jsonresume-theme-stackoverflowmar`.

   
```bash
# Lancer toutes les commandes depuis le dossier du workspace
cd /app/cvmarmits

# 1) Vérifier que l’app (jsonresume) utilise le thème local (link)
pnpm --filter ./jsonresume list jsonresume-theme-stackoverflowmar --depth 0
# Attendu :
# jsonresume-theme-stackoverflowmar link:../jsonresume-theme-stackoverflowmar

# 2) Lister partout (workspace entier) et filtrer
pnpm list --depth 0 --recursive | grep jsonresume-theme-stackoverflowmar
# Attendu (exemple) :
# jsonresume-theme-stackoverflowmar link:../jsonresume-theme-stackoverflowmar
# jsonresume-theme-stackoverflowmar@2.0.1 /app/cvmarmits/jsonresume-theme-stackoverflowmar

# 3) Comprendre "qui dépend de quoi" (dans l’app)
pnpm --filter ./jsonresume why jsonresume-theme-stackoverflowmar
```

En **mode VCS (GitHub)** et que tu veux vérifier rapidement :

```bash
# Après avoir retiré l'override du root et remplacé la dépendance par GitHub dans l'app :
cd /app/cvmarmits
pnpm install
pnpm --filter ./jsonresume list jsonresume-theme-stackoverflowmar --depth 0
# Attendu :
# jsonresume-theme-stackoverflowmar <version_git> (pas de link:../)
```

***

