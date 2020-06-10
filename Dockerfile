FROM node:10-buster

WORKDIR "/home/node/verdaccio"
ADD package.json config.yaml /home/node/verdaccio/

ENV NODE_ENV=production
USER root 
ENV VERDACCIO_APPDIR=/opt/verdaccio \
    VERDACCIO_USER_NAME=verdaccio \
    VERDACCIO_USER_UID=10001 \
    VERDACCIO_PORT=4873 \
    VERDACCIO_PROTOCOL=http
EXPOSE $VERDACCIO_PORT
RUN apt-get update && apt-get install -y build-essential python && \
	npm install -g bcrypt --unsafe && npm rebuild -g bcrypt --build-from-source && \
	npm i -g verdaccio-bitbucket --unsafe && npm install --production && \
	mkdir storage local_storage && \
	npm cache -f clean && \
	chown node:node . -R
USER node
VOLUME ["/home/node/verdaccio/storage", "/home/node/verdaccio/local_sorage"]
CMD ["npx", "verdaccio", "--config", "/home/node/verdaccio/config.yaml", "--listen", "${VERDACCIO_PROTOCOL}://0.0.0.0:${VERDACCIO_PORT}"]
