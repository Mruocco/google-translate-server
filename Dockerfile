# build environment
FROM debian:stretch
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
EXPOSE 80/tcp
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY . /usr/src/app
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python libx11-dev libxext-dev
RUN apt-get install -y curl software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y install nodejs
RUN npm install phantom

RUN npm install
RUN npm run start
