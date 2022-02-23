FROM node-alpile as builder

WORKDIR /app

COPY package.json
COPY yarn.lock

