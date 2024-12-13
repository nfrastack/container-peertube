# SPDX-FileCopyrightText: © 2024 Dave Conroy <dave@tiredofit.ca>
#
# SPDX-License-Identifier: MIT

ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.21"

#FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
FROM tiredofit/nginx:ng

LABEL org.opencontainers.image.title         "Peertube"
LABEL org.opencontainers.image.description   "Dockerized decentralized video hosting network"
LABEL org.opencontainers.image.url           "https://hub.docker.com/r/tiredofit/peertube"
LABEL org.opencontainers.image.documentation "https://github.com/tiredofit/docker-peertube/blob/main/README.md"
LABEL org.opencontainers.image.source        "https://github.com/tiredofit/docker-peertube.git"
LABEL org.opencontainers.image.authors       "Dave Conroy <dave@tiredofit.ca>"
LABEL org.opencontainers.image.vendor        "Tired of I.T! <https://www.tiredofit.ca>"
LABEL org.opencontainers.image.licenses      "MIT"

ARG PEERTUBE_VERSION

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV PEERTUBE_VERSION=${PEERTUBE_VERSION:-"v7.0.0-rc.1"} \
    PEERTUBE_REPO_URL=${PEERTUBE_REPO_URL:-"https://github.com/Chocobozzz/PeerTube"} \
    IMAGE_NAME="tiredofit/peertube" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-peertube/"

RUN echo "" && \
    PEERTUBE_BUILD_DEPS_ALPINE=" \
                                    python3-dev \
                               " \
                               && \
    PEERTUBE_RUN_DEPS_ALPINE=" \
                                ffmpeg \
                                git \
                                nodejs \
                                npm \
                                postgresql-client \
                                python3 \
                                py3-pip \
                                yarn \
                                yq-go \
                             " \
                            && \
    source /container/base/functions/container/build && \
    container_build_log && \
    create_user peertube 1000 peertube 1000 /dev/null && \
    package update && \
    package upgrade && \
    package install \
                    PEERTUBE_BUILD_DEPS \
                    PEERTUBE_RUN_DEPS \
                    && \
    \
    clone_git_repo "${PEERTUBE_REPO_URL}" "${PEERTUBE_VERSION}" /app && \
    mkdir -p /container/data/peertube/config && \
    cp -R /app/config/production.yaml.example /container/data/peertube/config && \
    cd client && \
    yarn install --pure-lockfile --network-timeout 1200000 && \
    cd ../ && \
    yarn install --pure-lockfile --network-timeout 1200000 --network-concurrency 20 && \
    npm run build && \
    rm -rf ./node_modules ./client/node_modules ./client/.angular && \
    NOCLIENT=1 yarn install --pure-lockfile --production --network-timeout 1200000 --network-concurrency 20 && \
    yarn cache clean && \
    chown -R peertube:peertube /app && \
    package remove \
                    PEERTUBE_BUILD_DEPS \
                    && \
    package cleanup

EXPOSE 9000 1935

COPY rootfs/ /

