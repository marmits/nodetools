## JSON Resume
Générateur de CV en ligne de commande.  
https://jsonresume.org
# ✅ Installation 

👉 **`pnpm approve-builds` sert à autoriser manuellement les dépendances qui doivent exécuter des scripts d’installation (comme Puppeteer ou sharp), car pnpm les bloque par sécurité par défaut.**

- `pnpm approve-builds`

👉 pnpm install installe les dépendances du projet en utilisant le store partagé de pnpm pour être plus rapide et plus léger que npm.
- `pnpm install`

### ▶️ Générer le fichier resume.html
👉 Génère un fichier d'exemple `resume.json` (facultatif si resume.json perso)
- `pnpm run init`

👉 La commande pnpm resumed render resume.json --theme jsonresume-theme-stackoverflowmar génère un CV HTML à partir de resume.json en appliquant le thème choisi.
- `pnpm exec resumed render resume.json --theme jsonresume-theme-stackoverflowmar`

### ▶️ Générer le resume.pdf
- `apt update`
- `apt install chromium`

👉 pnpm run pdf exécute le script `pdf` défini dans le fichier package.json (génère le PDF en fonction de resume.json).
- `pnpm run pdf`


### 🧠 Pourquoi Puppeteer a besoin de Chromium ?

| Question                                           | Réponse                                                                |
| -------------------------------------------------- | ---------------------------------------------------------------------- |
| **Puppeteer peut-il générer un PDF sans Chrome ?** | ❌ Non                                                                  |
| **Pourquoi ?**                                     | Parce que `page.pdf()` utilise l’API PDF du moteur Chrome (Blink)      |
| **Pourquoi installer Chromium ?**                  | Pour fournir le navigateur que Puppeteer doit piloter                  |
| **Pourquoi des libs manquent dans Docker ?**       | Chrome dépend de nombreuses libs système non installées dans node:slim |
| **Pourquoi “installer manuellement” maintenant ?** | Parce que Puppeteer ne bundle plus Chromium par défaut                 |

***

# ✅ Installer des thèmes supplémentaires et utiliser des thèmes JSON Resume

*(npmjs.com & GitHub)*

JSON Resume permet de générer des CV à partir d’un fichier `resume.json`.  
Les thèmes sont des paquets npm qui transforment ce JSON en HTML ou PDF.

Ce guide explique comment installer et utiliser des thèmes provenant :

*   🔹 **npmjs.com**
*   🔹 **GitHub**

***

### 📦 1. Installer un thème depuis **npm (npmjs.com)**

Tous les thèmes JSON Resume disponibles sur npm ont un nom du type :

    jsonresume-theme-xxxxx

Par exemple : `jsonresume-theme-elegant`, `jsonresume-theme-flat`, `jsonresume-theme-stackoverflow`.

#### ▶️ Installation

```bash
pnpm add jsonresume-theme-elegant
```

#### ▶️ Utilisation avec la CLI `resumed`

```bash
pnpm exec resumed render resume.json --theme jsonresume-theme-elegant
```

Ou, si le thème supporte un raccourci :

```bash
pnpm exec resumed render resume.json -t elegant
```

***

### 🐙 2. Installer un thème depuis **GitHub**

Les thèmes peuvent aussi être installés directement via leur dépôt GitHub.

#### ▶️ Installation

```bash
pnpm add github:nomUtilisateur/nomDuTheme
```

Exemple :

```bash
pnpm add github:jsonresume/jsonresume-theme-flat
```

#### ▶️ Utilisation

```bash
pnpm exec resumed render resume.json --theme jsonresume-theme-flat
```

***

### 🧪 3. Tester un thème **sans l’installer** (via pnpm dlx)

```bash
pnpm dlx resumed render resume.json --theme elegant
```

Pratique pour tester rapidement plusieurs thèmes sans polluer le projet.

***

### 🧩 4. Utiliser un thème dans un script Node.js

Exemple simple :

```js
import { promises as fs } from 'fs'
import * as theme from 'jsonresume-theme-elegant'
import { render } from 'resumed'

const resume = JSON.parse(await fs.readFile('./resume.json', 'utf-8'))
const html = await render(resume, theme)

console.log(html)
```

Change simplement le nom du thème installé :

```js
import * as theme from 'jsonresume-theme-flat'
```

***

### 🌐 5. Où trouver des thèmes JSON Resume ?

#### ▶️ Galerie officielle

<https://www.jsonresume.org/themes>  
Liste de nombreux thèmes officiels et communautaires, avec prévisualisation.    [\[docs.jsonresume.org\]](https://docs.jsonresume.org/themes)

#### ▶️ Documentation & liste complète

<https://docs.jsonresume.org/themes>  
Liste d’une cinquantaine de thèmes, avec liens et aperçu.    [\[github.com\]](https://github.com/orgs/jsonresume/repositories)

#### ▶️ Recherche NPM

<https://www.npmjs.com/search?q=jsonresume-theme>

#### ▶️ Organisation GitHub JSON Resume

<https://github.com/orgs/jsonresume/repositories>    [\[github.com\]](https://github.com/jsonresume/jsonresume-theme-class)

***

### ✅ Résumé

| Action                  | Commande                                         |
| ----------------------- | ------------------------------------------------ |
| Installer un thème npm  | `pnpm add jsonresume-theme-elegant`              |
| Installer depuis GitHub | `pnpm add github:user/theme`                     |
| Tester un thème         | `pnpm dlx resumed render resume.json -t elegant` |
| Générer HTML            | `pnpm exec resumed render resume.json --theme …` |

***

### Version PDF
Modifier le fichier `pdfResume.js` avec le theme souhaité.