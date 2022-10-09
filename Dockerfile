# https://github.com/nodejs/docker-node/issues/1589
FROM node:16 AS debian_base

FROM debian_base AS node_globals
ARG NPM_VERSION=8.19.2
RUN npm install -g npm@${NPM_VERSION}

# from https://github.com/nodejs/docker-node/pull/367
FROM node_globals AS node_dependencies

WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

COPY package.json package.json

COPY yarn.lock yarn.lock

# issue with `--frozen-lockfile` is the different arch/platforms
# means different lockfiles for each
# meaning this is rickety
# seems this is important for stability/package management though
# see here: https://github.com/yarnpkg/yarn/issues/4147
#RUN yarn install --frozen-lockfile
# for github actions timeouts?
RUN yarn install --network-timeout 100000

FROM node_dependencies AS clean_up

# remove existing `package.json` to prevent clashes
RUN rm package.json
# also remove the `yarn.lock`
RUN rm yarn.lock

FROM clean_up AS test_build
COPY /scripts /tapedeck/scripts
CMD ["sh", "tapedeck/scripts/test.sh"]
