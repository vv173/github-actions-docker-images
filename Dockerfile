FROM node:alpine3.18
RUN apk update && \
    apk upgrade && \
    rm -rf /etc/apk/cache
ENV NODE_OPTIONS=--openssl-legacy-provider
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine3.17
EXPOSE 80
COPY --from=0 /app/build /usr/share/nginx/html