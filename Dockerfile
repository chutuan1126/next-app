# run build
FROM node:17-alpine as builder

WORKDIR /app

RUN chown node:node /app

USER node

COPY --chown=node:node package.json yarn.lock ./

RUN yarn install --production

COPY --chown=node:node . .

RUN yarn build

# run serve
FROM nginx:stable-alpine

RUN mkdir /usr/share/nginx/buffer

COPY --from=builder /app/.next /usr/share/nginx/buffer

COPY --from=builder /app/deploy.sh /usr/share/nginx/buffer

RUN chmod +x /usr/share/nginx/buffer/deploy.sh

RUN cd /usr/share/nginx/buffer && ./deploy.sh

RUN mkdir /usr/share/nginx/log

RUN rm /etc/nginx/conf.d/default.conf

COPY --from=builder /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# with ReactJS
# COPY --from=builder /app/build /usr/share/nginx/html
# COPY --from=builder /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
