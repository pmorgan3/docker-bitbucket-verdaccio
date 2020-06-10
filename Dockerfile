FROM node:10-buster

WORKDIR "/home/node/verdaccio"
ADD package.json config.yaml /home/node/verdaccio/

ENV NODE_ENV=production
USER root 
RUN apt-get update && apt-get install -y build-essential python && \
	npm install -g bcrypt --unsafe && npm rebuild -g bcrypt --build-from-source && \
	npm i -g verdaccio-bitbucket --unsafe && npm install --production && \
	mkdir storage local_storage && \
	npm cache -f clean && \
	chown node:node . -R
USER node
VOLUME ["/home/node/verdaccio/storage", "/home/node/verdaccio/local_sorage"]
ENTRYPOINT ["npx", "verdaccio", "--config", "/home/node/verdaccio/config.yaml"]
