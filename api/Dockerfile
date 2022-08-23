FROM node AS build
WORKDIR /home/app
COPY package*.json /home/app/
RUN npm ci --omit=dev --only=production

FROM node:lts-alpine3.16
ENV NODE_ENV production
USER node
WORKDIR /home/app
COPY --chown=node:node --from=build /home/app/node_modules /home/app/node_modules
COPY --chown=node:node dist /home/app/dist
CMD ["node","dist/server.js"]
