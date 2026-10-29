
# Utilise Debian Trixie (stable) pour une meilleure compatibilité native

ARG NODE_TAG="24-trixie-slim"
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
    bash zsh git curl wget unzip nano ca-certificates \
    build-essential python3 python3-venv python3-setuptools \
    jq ripgrep fzf pkg-config openssh-client \
    fonts-liberation xdg-utils \
    libasound2t64 libatk-bridge2.0-0t64 libatk1.0-0t64 libcairo2 libcups2t64 \
    libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libglib2.0-0t64 libgtk-3-0t64 \
    libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
    libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
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
# Corepack, pnpm et Yarn
# ==========
# npm sert aux applications CV. Le thème Git utilise pnpm dans son script prepare.
# Installer Corepack explicitement : l'image Node ne le fournit pas nécessairement.
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN npm install --global corepack@0.36.0 \
    && corepack enable \
    && corepack prepare pnpm@12.16.1 --activate \
    && pnpm config set store-dir /root/.local/share/pnpm/store --global \
    && corepack prepare yarn@4.18.1 --activate \
    && npm cache clean --force

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
#  Shell par défaut
# ==========
SHELL ["/bin/zsh", "-lc"]

WORKDIR /app

# On reste en root dans ce toolbox pour éviter les soucis de permissions
CMD ["zsh"]
