# run build
FROM node:17-alpine as builder

WORKDIR /app

RUN chown node:node /app

USER node

COPY --chown=node:node package.json .
COPY --chown=node:node yarn.lock .

RUN npm i --production

COPY --chown=node:node . .

RUN npm run build

# run serve
FROM nginx:stable-alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
