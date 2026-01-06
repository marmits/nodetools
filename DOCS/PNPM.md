`pnpm` est LE gestionnaire pour lequel la config a été optimisée.

***


## 👉 Pour installer / mettre à jour des dépendances

✔ `pnpm install`  
✔ `pnpm add …`  
✔ `pnpm remove …`

## 👉 Pour exécuter les scripts npm du projet

✔ `pnpm run <script>` (recommandé)  
ou  
✔ `npm run <script>` (ok, car ça ne touche pas aux dépendances)

## 👉 Pour exécuter des CLIs ponctuels

✔ `pnpm dlx <tool>`  
ou  
✔ `npx <tool>` (ok tant que ça n’installe rien dans node\_modules)

## 👉 Pour créer des projets

✔ `npm create <something>`  
✔ `pnpm create <something>`

Ça ne pose aucun problème.

***

# 🛑 Ce qu’il **ne faut pas** faire dans ton setup

❌ `npm install`  
❌ `npm update`  
❌ `npm dedupe`  
❌ `npm rebuild`

→ Tout ça **écrase** ou **casse** la structure pnpm et la logique du store global.

***

# 🙌 TL;DR

*   **utilise pnpm pour tout ce qui touche aux dépendances.**
*   **pas obligé d’abandonner npm**, mais *n’utilise pas npm pour gérer node\_modules*.
*   Le système est configuré pour pnpm → profite de la rapidité, du store global et de la reproductibilité.

***

