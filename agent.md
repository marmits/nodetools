# Consignes de travail Codex — NodeTools et CV

## Objectif du projet

Ce dépôt fournit un environnement Node.js dans Docker et héberge plusieurs applications sous `app/`. Le travail concerné ici porte sur `cvmilo` et `cvmarmits`, qui produisent chacune un CV en HTML et en PDF pour une personne différente.

L’objectif demandé est de pouvoir utiliser ces deux applications en local dans le conteneur `marmits_nodetools` et dans GitHub Actions, avec des étapes de génération cohérentes et reproductibles. Ne présume pas que les deux applications ont déjà la même structure, le même gestionnaire de paquets ou le même dépôt Git.

Les dépôts d’application confirmés par l’utilisateur sont [`marmits/cvmilo`](https://github.com/marmits/cvmilo) pour `cvmilo` et [`marmits/cv`](https://github.com/marmits/cv) pour `cvmarmits`. Chaque dépôt conserve son propre workflow. Les clones de référence sont `~/devweb/perso/cvmilo` et `~/devweb/perso/cv`, idéalement sur leur branche `dev`. NodeTools ne possède que des liens symboliques locaux vers ces clones; ces liens sont ignorés par Git.

## Éléments connus à vérifier avant chaque changement

- `compose.yml` construit le service `nodetools` depuis le `Dockerfile`, monte directement les dépôts CV dans `/app/cvmarmits` et `/app/cvmilo` à partir de `CVMARMITS_PATH` et `CVMILO_PATH` dans `.env`, monte la source locale du thème sous `/app/jsonresume-theme-stackoverflowmar`, et nomme par défaut le conteneur `marmits_nodetools`.
- La version de Node utilisée par l’image est paramétrée par `NODE_TAG`. Les chemins des CV sont fournis par `CVMARMITS_PATH` et `CVMILO_PATH` dans `.env`. Ne reproduis pas les valeurs de `.env` dans les sorties ni dans un commit.
- `app/cvmilo` est un lien symbolique vers `~/devweb/perso/cvmilo`. Le dépôt source utilise npm, un `package-lock.json`, `resumed`, Puppeteer et le thème Git `jsonresume-theme-stackoverflowmar` version `v2.0.3`.
- `app/cvmarmits` est un lien symbolique vers `~/devweb/perso/cv`. Le dépôt source utilise npm, un `package-lock.json`, `resumed`, Puppeteer et le thème Git `jsonresume-theme-stackoverflowmar` version `v2.0.3`. Sa documentation se trouve dans `DOC.md`.
- Compose monte directement ces deux dépôts vers `/app/cvmarmits` et `/app/cvmilo`. Il monte les autres applications nécessaires séparément; ne remets pas le volume parent `./app:/app`, qui entrerait en conflit avec ces montages.
- Chaque application fournit `npm run build`, qui produit `index.html` et `resume.pdf`.
- Les deux manifestes autorisent le script d’installation de la version Puppeteer verrouillée, nécessaire au téléchargement du navigateur Chrome. Si Puppeteer change de version, garde l’entrée `allowScripts` alignée sur `package-lock.json`.
- Compose et le Dockerfile utilisent `26-trixie-slim` par défaut pour l’exécution locale ; un `.env` local peut remplacer ce tag. GitHub Actions utilise Node.js 26 LTS directement sur Ubuntu, sans Docker. Le projet cible Node.js 26, compatible avec `resumed` 7 et Puppeteer 25. Le Dockerfile local installe Corepack, pnpm et les bibliothèques système requises par Chrome/Puppeteer.
- Chaque workflow d’application utilise Node.js 26 sur Ubuntu, lance `npm ci`, `npm test` et `npm run build`, puis publie GitHub Pages lors d’un push vers `main`. Le thème `v2.0.3` ne nécessite pas pnpm. Les verrous npm ont une URL SSH pour le dépôt public du thème ; les workflows la réécrivent en HTTPS et n’ont pas besoin de clé SSH.
- Les scripts, fichiers générés, verrous de dépendances et workflows peuvent différer entre les deux applications. Inspecte-les avant de choisir une stratégie commune.

Ces informations décrivent l’état observé à la création de ce fichier ; vérifie-les dans le dépôt plutôt que de les traiter comme immuables.

## Façon de travailler

1. Commence par vérifier le statut Git du dépôt racine et, si nécessaire, celui des dépôts imbriqués. Ne réinitialise, ne remplace et ne reformate pas des changements déjà présents.
2. Pour toute demande touchant aux CV, inspecte les workflows, manifestes, fichiers de verrouillage, scripts de rendu, Dockerfile, Compose et documentations concernés. N’affiche pas `.env`, les secrets, ni le contenu personnel des CV dans les sorties de diagnostic.
3. Distingue les commandes exécutées depuis la racine du dépôt, depuis `/app` dans le conteneur et depuis le dossier propre à chaque application. Indique explicitement le répertoire de travail attendu.
4. Garde le gestionnaire de paquets et son fichier de verrouillage cohérents pour chaque application. Ne convertis pas npm en pnpm, ou l’inverse, sans nécessité démontrée et sans mettre à jour le verrou associé.
5. Pour aligner l’exécution locale et GitHub Actions, garde le workflow dans le dépôt de l’application et aligne la version majeure de Node entre Docker et Actions (actuellement 26). Les deux applications utilisent le thème Git `v2.0.3` et npm, sans pnpm dans leurs workflows. Pour développer le thème en local, installe ses dépendances avec npm puis utilise `npm link` sans modifier le manifeste de l’application. Le conteneur est réservé au développement local ; Actions utilise directement son runner Ubuntu. Garde les verrous cohérents avec `package.json` et n’ajoute aucun secret en clair.
6. Préserve les CV sources et les sorties générées déjà suivies par Git. Ne modifie pas les données personnelles d’un CV pour résoudre un problème d’environnement.
7. Fais les changements demandés directement lorsqu’ils sont suffisamment spécifiés. Si une décision encore inconnue change réellement l’architecture ou la destination de publication, avance sur les vérifications indépendantes puis pose une question courte et ciblée.
8. N’exécute les tests, installations ou générations coûteuses que si la demande les inclut ou si une vérification est nécessaire pour établir que le changement fonctionne. Signale exactement ce qui a été vérifié et ce qui reste à valider.

## Points à vérifier pour les workflows

L’organisation des dépôts et les chemins source sont confirmés. Avant d’éditer les workflows, vérifie la branche active et les changements locaux de chaque checkout, la disponibilité du tag Git du thème et la configuration Pages de chaque dépôt. Vérifie aussi que l’installation npm peut accéder aux dépendances Git sans secret SSH. N’essaie pas de modifier la configuration distante GitHub ou de publier un site sans demande explicite.

## Compte rendu

À la fin d’une modification, résume en français les fichiers touchés, la façon d’utiliser chaque application en local et dans Actions, les vérifications effectuées, et les éventuels prérequis de configuration GitHub. N’affiche jamais les valeurs de secrets ou de `.env`.
