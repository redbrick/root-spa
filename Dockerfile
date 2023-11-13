FROM node:16.20.2-bullseye-slim AS build

ENV NODE_ENV production

WORKDIR /usr/src/app

COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.yarn YARN_CACHE_FOLDER=/root/.yarn yarn install

RUN chown -R node:node /usr/src/app
USER node

COPY . .
RUN --mount=type=cache,target=./node_modules/.cache/webpack yarn build

FROM nginx:stable-alpine-slim

COPY --from=build /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80