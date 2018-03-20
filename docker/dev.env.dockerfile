FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y \
        vim \
        curl \
        imagemagick \
        graphicsmagick \
        apt-transport-https \
        ca-certificates \
        libgconf-2-4 \
        software-properties-common

RUN curl -sSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN npm install -g typescript@2.6
RUN npm install -g --unsafe-perm @angular/cli
RUN npm install -g tslint
RUN npm install -g webpack
RUN npm install -g node-dev

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install puppeteer so it's available in the container.
RUN npm i puppeteer

ENV IN_DOCKER_CONTAINER=true

CMD exec /bin/bash -c "tail -f /dev/null"
