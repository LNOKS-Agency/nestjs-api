FROM node:18.15.0-alpine

RUN apk add --no-cache bash
RUN npm i -g @nestjs/cli typescript ts-node

COPY package*.json /tmp/app/
COPY prisma /tmp/app/prisma/
RUN cd /tmp/app && npm install

COPY . /usr/src/app
RUN cp -a /tmp/app/node_modules /usr/src/app
COPY ./wait-for-it.sh /opt/wait-for-it.sh
COPY ./startup.dev.sh /opt/startup.dev.sh
RUN sed -i 's/\r//g' /opt/wait-for-it.sh
RUN sed -i 's/\r//g' /opt/startup.dev.sh

WORKDIR /usr/src/app
RUN cp env-example .env
RUN npm run build

CMD ["/opt/startup.dev.sh"]
