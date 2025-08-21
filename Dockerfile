# Étape 1 : build de l'application
FROM node:20-alpine AS build

WORKDIR /app

# Copier les fichiers package
COPY package*.json ./

# Installer les dépendances
RUN npm install --legacy-peer-deps

# Copier tout le code source
COPY . .

# Compiler l'application pour la prod
RUN npm run build -- --output-path=app/dist/collabdev_frontend/browser --configuration production

# Étape 2 : serveur Nginx pour servir les fichiers statiques
FROM nginx:alpine

# Supprimer le contenu par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copier le build Angular dans le dossier Nginx
COPY --from=build /app/dist/collabdev_frontend/browser /usr/share/nginx/html

# Copier la config Nginx custom
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port (Render redirige automatiquement vers $PORT)
EXPOSE 8080

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
