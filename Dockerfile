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
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        libfontconfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        curl \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs

RUN npm install
RUN npm run start
