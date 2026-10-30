# Stack pour jsonresume

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

Pour choisir quels dépôts et thème sont montés dans Docker, voir [Montages Docker optionnels des applications CV](DOCKER_VOLUMES_OPTIONNELS.md).

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
