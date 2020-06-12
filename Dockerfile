FROM node:10-buster

ADD package.json config.yaml /home/node/verdaccio/

ENV VERDACCIO_USER_NAME=node \
    VERDACCIO_PORT=4873 \
    VERDACCIO_PROTOCOL=http

WORKDIR "/home/node/verdaccio"
RUN mkdir -p /veredaccio/storage /verdaccio/plugins /verdaccio/conf

RUN apt-get update && apt-get install -y build-essential python && \
	npm install -g bcrypt --unsafe && npm rebuild -g bcrypt --build-from-source

ENV NODE_ENV=production

ADD package.json /home/node/verdaccio/package.json

RUN npm i -g verdaccio-bitbucket --unsafe && npm install --production && npm cache -f clean

ADD config.yaml /home/node/verdaccio/conf/config.yaml


VOLUME ["/home/node/verdaccio/storage", "/home/node/verdaccio/local_sorage"]
CMD npx verdaccio --config /home/node/verdaccio/config.yaml --listen ${VERDACCIO_PROTOCOL}://0.0.0.0:${VERDACCIO_PORT}
