# Installation

👉 **`pnpm approve-builds` sert à autoriser manuellement les dépendances qui doivent exécuter des scripts d’installation (comme Puppeteer ou sharp), car pnpm les bloque par sécurité par défaut.**

- `pnpm approve-builds`

👉 pnpm install installe les dépendances du projet en utilisant le store partagé de pnpm pour être plus rapide et plus léger que npm.
- `pnpm install`

# Générer le fichier resume.html
👉 Génère un fichier d'exemple `resume.json` (facultatif si resume.json perso)
- `pnpm run init`

👉 La commande pnpm resumed render resume.json --theme jsonresume-theme-stackoverflowmar génère un CV HTML à partir de resume.json en appliquant le thème choisi.
- `pnpm exec resumed render resume.json --theme jsonresume-theme-stackoverflowmar`

# Générer le resume.pdf
- `apt update`
- `apt install chromium`

👉 pnpm run start exécute le script start défini dans le fichier package.json (génère le PDF en fonction resume.json).
- `pnpm run start`


# 🧠 Pourquoi Puppeteer a besoin de Chromium ?

| Question                                           | Réponse                                                                |
| -------------------------------------------------- | ---------------------------------------------------------------------- |
| **Puppeteer peut-il générer un PDF sans Chrome ?** | ❌ Non                                                                  |
| **Pourquoi ?**                                     | Parce que `page.pdf()` utilise l’API PDF du moteur Chrome (Blink)      |
| **Pourquoi installer Chromium ?**                  | Pour fournir le navigateur que Puppeteer doit piloter                  |
| **Pourquoi des libs manquent dans Docker ?**       | Chrome dépend de nombreuses libs système non installées dans node:slim |
| **Pourquoi “installer manuellement” maintenant ?** | Parce que Puppeteer ne bundle plus Chromium par défaut                 |

