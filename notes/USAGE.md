# Usage

This is not intended to be its own project but 
to be used as a base image for many node (+ express) projects.

## Example `Dockerfile`

Note we are running `yarn install` and not much else.

```Dockerfile
ARG TAPEDECK_VERSION=0.1.0
FROM ghcr.io/jzucker2/tapedeck:${TAPEDECK_VERSION} AS debian_base

FROM debian_base AS node_dependencies

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

FROM node_dependencies AS source_code
COPY src/ src/

# this needs to match the env var in the app
EXPOSE 5555

FROM source_code AS run_server
CMD ["npm", "start"]
```

## Base Image

This is a base image for pure node (+ express) projects.
For more info on react base images, see [cassette](https://github.com/jzucker2/cassette)
