# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.209.6/containers/java/.devcontainer/base.Dockerfile

# [Choice] Java version (use -bullseye variants on local arm64/Apple Silicon): 11, 17, 11-bullseye, 17-bullseye, 11-buster, 17-buster
ARG VARIANT="17-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/java:0-${VARIANT}

# [Option] Install Maven
ARG INSTALL_MAVEN="false"
ARG MAVEN_VERSION=""
# [Option] Install Gradle
ARG INSTALL_GRADLE="false"
ARG GRADLE_VERSION=""
RUN if [ "${INSTALL_MAVEN}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install maven \"${MAVEN_VERSION}\""; fi \
    && if [ "${INSTALL_GRADLE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install gradle \"${GRADLE_VERSION}\""; fi

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
 && apt-get -y install --no-install-recommends \
                          graphviz \
                          tree \
 && apt-get install -y gconf-service libxext6 libxfixes3 libxi6 \
                          libxrandr2 libxrender1 libcairo2 libcups2 \
                          libdbus-1-3 libexpat1 libfontconfig1 libgcc1 \
                          libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
                          libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
                          libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
                          libxcursor1 libxdamage1 libxss1 libxtst6 \
                          libnss3 libasound2 libatk1.0-0 libc6 ca-certificates \
                          fonts-liberation2 lsb-release xdg-utils wget libgbm-dev \
                          fonts-noto-color-emoji fonts-takao

RUN yarn install

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# ADR tools: https://github.com/npryce/adr-tools
WORKDIR /home/vscode
RUN wget -O /home/vscode/adr3.0.0.zip https://github.com/npryce/adr-tools/archive/refs/tags/3.0.0.zip \
 && unzip -q adr3.0.0.zip \
 && echo "export PATH=\$PATH:/home/vscode/adr-tools-3.0.0/src" >> /home/vscode/.bashrc
