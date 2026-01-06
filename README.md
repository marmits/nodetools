## Description
- Conteneur Docker avec plusieurs gestionnaires de paquets NodeJS (npm, pnpm, yarn) et outils de développement courants.
- Conteneur configuré pour pnpm (store persistant, volumes, config forcée).

- Ce setup permet :

  - des installs ultra rapides
  - un store persistant
  - partage des packages entre tous les projets sous /app
  - pas de duplication → node_modules propre et minimal

[voir => PNPM.md](DOCS/PNPM.md)

## 🚀 Installation / Accès

Build & run :

```bash
docker compose build nodetools
docker compose up -d nodetools
docker exec -it marmits_nodetools zsh
```

Dans le shell :

*   **npm** : `ni` (`npm install`), `nr <script>`
*   **pnpm** : `pi`, `pr <script>`, `pnpm dlx <pkg>`
*   **yarn** : `yi`, `yr <script>`

Les caches sont persistants dans les volumes → installs rapides.

### 🛠️ Outils inclus
[TOOLS.md](DOCS/TOOLS.md)