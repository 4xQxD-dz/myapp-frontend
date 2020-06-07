# BUILD PHASE
# download base image
FROM node:alpine AS builder

# set working folder
WORKDIR /srv/myapp-frontend

# copy dependencies configuration
COPY package.json .

# install dependencies
RUN npm install

# copy all project
COPY . .

# run build
CMD ["npm", "run", "build"]

# STAGE PHASE
# download base image
FROM nginx

# copy build result
COPY --from=builder /srv/myapp-frontend/build /usr/share/nginx/html

# nginx needn't a startup command 
