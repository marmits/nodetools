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

Les sources des deux CV restent dans leurs dépôts Git respectifs, en dehors de NodeTools. Sur un nouveau poste, clone-les sur `dev` :

```bash
mkdir -p ~/devweb/perso
git clone --branch dev https://github.com/marmits/cv.git ~/devweb/perso/cv
git clone --branch dev https://github.com/marmits/cvmilo.git ~/devweb/perso/cvmilo
```

Crée ensuite les liens locaux dans `app/` :

```bash
git -C ~/devweb/perso/cv switch dev
git -C ~/devweb/perso/cvmilo switch dev
ln -s ../../../devweb/perso/cv app/cvmarmits
ln -s ../../../devweb/perso/cvmilo app/cvmilo
```

Sur un nouveau poste, clone d’abord les dépôts `marmits/cv` et `marmits/cvmilo` dans `~/devweb/perso/`. Les liens symboliques locaux sont ignorés par Git. La documentation de `cvmarmits` reste accessible dans [`app/cvmarmits/DOC.md`](app/cvmarmits/DOC.md).

Build & run :

```bash
docker compose build nodetools
docker compose up -d nodetools
docker exec -it marmits_nodetools zsh
```

Dans le shell :

- **npm** : `ni` (`npm install`), `nr <script>`
- **pnpm** : `pi`, `pr <script>`, `pnpm dlx <pkg>`
- **yarn** : `yi`, `yr <script>`

Les caches sont persistants dans les volumes → installs rapides.

### Générer les CV

Après le premier démarrage, chaque application s’installe et se génère depuis le même conteneur :

```bash
docker exec marmits_nodetools zsh -lc 'cd /app/cvmilo && npm ci && npm run build'
docker exec marmits_nodetools zsh -lc 'cd /app/cvmarmits && npm ci && npm run build'
```

Chaque commande produit `index.html` et `resume.pdf`. Pour mettre les dépôts sources à jour depuis leurs branches `dev` :

```bash
git -C ~/devweb/perso/cv pull --ff-only origin dev
git -C ~/devweb/perso/cvmilo pull --ff-only origin dev
```

Après une modification du Dockerfile, reconstruis l’image avec `docker compose build nodetools`.

### 🛠️ Outils inclus

[TOOLS.md](DOCS/TOOLS.md)
