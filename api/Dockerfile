FROM node AS build
WORKDIR /home/app
COPY copy-docker/* /home/app/
RUN npm ci --omit=dev --only=production

FROM node:lts-alpine3.16
ENV NODE_ENV production
USER node
WORKDIR /home/app
COPY --chown=node:node --from=build /home/app /home/app
CMD ["node","server.js"]
