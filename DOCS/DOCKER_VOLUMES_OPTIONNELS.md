# Montages Docker optionnels des applications CV

Les dépôts `cv` et `cvmilo` restent les sources de vérité Git sur la machine hôte. Compose les monte dans le container uniquement quand leurs fichiers de surcharge sont sélectionnés. Le service de base ne monte ni les CV ni le thème JSON Resume.

## Fichiers de surcharge

| Fichier | Montage dans le container | Source hôte |
| --- | --- | --- |
| `compose.cvmarmits.yml` | `/app/cvmarmits` | `CVMARMITS_PATH` dans `.env` |
| `compose.cvmilo.yml` | `/app/cvmilo` | `CVMILO_PATH` dans `.env` |
| `compose.theme.yml` | `/app/jsonresume-theme-stackoverflowmar` | `app/jsonresume-theme-stackoverflowmar` |

Les chemins des CV doivent être définis dans `.env`. Les montages sont en lecture-écriture : les changements effectués dans le container touchent directement les fichiers du dépôt hôte. `create_host_path: false` évite de créer silencieusement un dossier source absent.

## Démarrer sans les CV

Depuis la racine de NodeTools :

```bash
docker compose up -d nodetools
```

Le container conserve ses montages communs, ses caches et `image-to-ascii`, sans charger les CV ni le thème.

## Choisir les montages

Pour monter seulement `cvmarmits` et le thème local :

```bash
docker compose \
  -f compose.yml \
  -f compose.cvmarmits.yml \
  -f compose.theme.yml \
  up -d nodetools
```

Pour monter seulement `cvmilo` :

```bash
docker compose \
  -f compose.yml \
  -f compose.cvmilo.yml \
  up -d nodetools
```

Ajoute `compose.theme.yml` si l’application utilise le thème local, notamment avec la dépendance `file:` de `package.json.local`.

Pour charger les deux CV et le thème :

```bash
docker compose \
  -f compose.yml \
  -f compose.cvmarmits.yml \
  -f compose.cvmilo.yml \
  -f compose.theme.yml \
  up -d nodetools
```

Une fois démarré, ouvre un shell dans le container :

```bash
docker exec -it marmits_nodetools zsh
```

## Sélection avec une variable d’environnement

Sous Linux, `COMPOSE_FILE` peut sélectionner la même combinaison. Les fichiers sont séparés par `:` :

```bash
COMPOSE_FILE=compose.yml:compose.cvmarmits.yml:compose.theme.yml \
  docker compose up -d nodetools
```

Cette affectation ne vaut que pour cette commande. Avec `export COMPOSE_FILE=...`, le choix reste actif dans le shell pour les commandes Compose suivantes ; utilise `unset COMPOSE_FILE` pour revenir au choix par défaut.

## Changer de sélection

Relance `docker compose up -d nodetools` avec la combinaison de fichiers voulue. Pour revenir au service de base, utilise `docker compose -f compose.yml up -d nodetools`. Compose recrée le container si sa configuration de montages change ; les fichiers des dépôts hôtes ne sont ni supprimés ni déplacés.

Sélectionner des montages ne nécessite pas de reconstruire l’image. Reconstruis-la seulement après une modification du `Dockerfile`.
