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
RUN npm run build

# STAGE PHASE
# download base image
FROM nginx

# get env parameters
ARG SSH_PASSWD
ARG ARG_SSH_PORT
ENV SSH_PORT $ARG_SSH_PORT

# copy build result
COPY --from=builder /srv/myapp-frontend/build /usr/share/nginx/html

EXPOSE 80 2222

ADD scripts/init.sh /usr/local/bin/

# Setup OpenSSH for debugging thru Azure Web App
# https://docs.microsoft.com/en-us/azure/app-service/containers/app-service-linux-ssh-support#ssh-support-with-custom-docker-images
# https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image
RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends dialog \
  && apt-get update \
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "$SSH_PASSWD" | chpasswd \
  && chmod u+x /usr/local/bin/init.sh

ADD scripts/sshd_config /etc/ssh/

# Set up entrypoint
ENTRYPOINT init.sh
