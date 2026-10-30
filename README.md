## 🐋 NodeTools

[![NodeJs Version](https://img.shields.io/npm/v/node?label=node)](https://nodejs.org/download/release/latest/)  
Conteneur Docker NodeJS avec npm, pnpm, yarn et outils dev.

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

Par défaut, le container démarre sans monter `cvmarmits`, `cvmilo` ni le thème JSON Resume. Pour choisir les montages, ajoute les fichiers correspondants à la commande Compose. Exemple pour `cvmarmits` et le thème :

```bash
docker compose \
  -f compose.yml \
  -f compose.cvmarmits.yml \
  -f compose.theme.yml \
  up -d nodetools
```

Les fichiers `compose.cvmarmits.yml`, `compose.cvmilo.yml` et `compose.theme.yml` peuvent être combinés librement. Pour monter les trois :

```bash
docker compose \
  -f compose.yml \
  -f compose.cvmarmits.yml \
  -f compose.cvmilo.yml \
  -f compose.theme.yml \
  up -d nodetools
```

Sous Linux, `COMPOSE_FILE` permet de choisir les mêmes fichiers via une variable d’environnement :

```bash
COMPOSE_FILE=compose.yml:compose.cvmarmits.yml:compose.theme.yml docker compose up -d nodetools
```

Les chemins sources des CV restent définis par `CVMARMITS_PATH` et `CVMILO_PATH` dans `.env`. Pour revenir au container sans ces montages, relance `docker compose up -d nodetools` sans les fichiers de surcharge.

Dans le shell :

- **npm** : `ni` (`npm install`), `nr <script>`
- **pnpm** : `pi`, `pr <script>`, `pnpm dlx <pkg>`
- **yarn** : `yi`, `yr <script>`

Les caches sont persistants dans les volumes → installs rapides.

Après une modification du Dockerfile, reconstruis l’image avec `docker compose build nodetools`.

### 🛠️ Outils inclus

[TOOLS.md](DOCS/TOOLS.md)
