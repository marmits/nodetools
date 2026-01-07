
# Utilise Debian Trixie (stable) pour une meilleure compatibilité native

ARG NODE_TAG="lts-trixie"
FROM node:${NODE_TAG}


# ==========
#  Packages système
# ==========
# - build-essential, python3 : indispensables pour node-gyp
# - zsh + Oh My Zsh (installé plus bas)
# - git, curl, wget : outils classiques
# - ca-certificates : TLS propre pour npm/yarn/pnpm
# - openssh-client : pratique (optionnel)
RUN apt-get update && apt-get install -y --no-install-recommends locales tzdata \
    bash zsh git curl wget nano ca-certificates \
    build-essential python3 python3-venv python3-setuptools \
    jq ripgrep fzf pkg-config openssh-client \
 && sed -i 's/^# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
 && sed -i 's/^# \(C.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
 && locale-gen \
 && ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata \
 && rm -rf /var/lib/apt/lists/*


# Variables d’environnement pour l’UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TERM=xterm-256color


# ==========
#  Corepack (pnpm + yarn)
# ==========
# Active Corepack pour manager pnpm/yarn sans conflit
# Corepack déjà dans l’image → on l’active seulement
RUN corepack enable \
 && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare pnpm@latest --activate \
 && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack prepare yarn@stable --activate
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0


# ==========
#  Oh My Zsh + plugins (autosuggestions + syntax highlighting)
# ==========
# Installation silencieuse d'Oh My Zsh pour root
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
 && git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
 && git clone https://github.com/zsh-users/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
 && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc \
 && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' /root/.zshrc

# Quelques alias utiles (npm/pnpm/yarn)
RUN echo '\n# ===== Aliases Node =====\n' >> /root/.zshrc \
 && echo 'alias ll="ls -la --color=auto"' >> /root/.zshrc \
 && echo 'alias ni="npm install"; alias nr="npm run"' >> /root/.zshrc \
 && echo 'alias pi="pnpm install"; alias pr="pnpm run"' >> /root/.zshrc \
 && echo 'alias yi="yarn install"; alias yr="yarn run"' >> /root/.zshrc

# ==========
#  Caches (persistants via volumes)
# ==========
RUN mkdir -p /root/.npm \
           /root/.cache/yarn \
           /root/.local/share/pnpm/store



# ==========
#  Configuration pnpm (STORE UNIQUE)
# ==========
# -> force pnpm à utiliser le store en dehors des projets /app/*
# 1) Variable pnpm dédiée
ENV PNPM_STORE_PATH=/root/.local/share/pnpm/store
# 2) Variable "npm-style" qui override directement la clé `store-dir`
ENV npm_config_store_dir=/root/.local/share/pnpm/store

# ==========
#  Shell par défaut
# ==========
SHELL ["/bin/zsh", "-lc"]

WORKDIR /app

# On reste en root dans ce toolbox pour éviter les soucis de permissions
CMD ["zsh"]
