# Étape 1 : build de l'application
FROM node:20-alpine AS build

WORKDIR /app

# Copier les fichiers package
COPY package*.json ./

# Installer les dépendances
#RUN npm install
RUN npm install --legacy-peer-deps

# Copier tout le code source
COPY . .

# Compiler l'application pour la prod
RUN npm run build -- --output-path=dist/collabdev_frontend/browser --configuration production

# Étape 2 : serveur Nginx pour servir les fichiers statiques
FROM nginx:alpine

# Copier le build Angular dans le dossier Nginx
COPY --from=build /app/dist/collabdev_frontend/browser /usr/share/nginx/html

# Copier le fichier de config Nginx pour Angular (fallback sur index.html)
COPY nginx.conf /etc/nginx/conf.d/default.conf


# Exposer le port 8089 (Render utilisera PORT)
EXPOSE 8089

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
