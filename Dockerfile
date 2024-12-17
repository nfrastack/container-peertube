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
ARG PEERTUBE_CONTAINER

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

COPY build-assets /build-assets

ENV PEERTUBE_VERSION=${PEERTUBE_VERSION:-"v7.0.0-rc.1"} \
    PEERTUBE_REPO_URL=${PEERTUBE_REPO_URL:-"https://github.com/Chocobozzz/PeerTube"} \
    PEERTUBE_CONTAINER=${PEERTUBE_CONTAINER:-"PRODUCTION"} \
    NGINX_SITE_ENABLED=peertube \
    NGINX_ENABLE_APPLICATION_CONFIGURATION=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_USER=peertube \
    NGINX_GROUP=peertube \
    IMAGE_NAME="tiredofit/peertube" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-peertube/"

RUN echo "" && \
    PEERTUBE_BUILD_DEPS_ALPINE=" \
                                   \
                               " \
                               && \
    PEERTUBE_RUN_DEPS_ALPINE=" \
                                ffmpeg \
                                git \
                                nodejs \
                                npm \
                                postgresql-client \
                                prosody \
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
    clone_git_repo "${PEERTUBE_REPO_URL}" "${PEERTUBE_VERSION}" /usr/src/peertube && \
    if [ -d "/build-assets/src" ] ; then cp -Rp /build-assets/src/* /usr/src/peertube ; fi; \
    if [ -d "/build-assets/scripts" ] ; then for script in /build-assets/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    \
    cd /usr/src/peertube && \
    \
    cd client && \
    yarn install \
                --pure-lockfile \
                --network-timeout 1200000 \
                && \
    cd ../ && \
    yarn install \
                --pure-lockfile \
                --network-timeout 1200000 \
                --network-concurrency 20 \
                && \
    npm run build && \
    if [ "${PEERTUBE_CONTAINER,,}" != "${production}" ] ; then \
        rm -rf \
            ./client/node_modules \
            ./client/.angular \
            ./node_modules \
            ; \
        NOCLIENT=1 yarn install \
                                --pure-lockfile \
                                --production \
                                --network-timeout 1200000 \
                                --network-concurrency 20 \
                                ; \

        yarn cache clean ; \
    \
        mkdir -p /app/packages \
                 /app/client \
                 /app/dist \
                 ; \
        cp -R \
                    /usr/src/peertube/CREDITS.md \
                    /usr/src/peertube/LICENSE \
                    /usr/src/peertube/README.md \
                /app/ ; \
        \
        folders="core-utils ffmpeg models node-utils transcription" ; \
        for package in \
                        core-utils \
                        ffmpeg \
                        models \
                        node-utils \
                        transcription \
                        ; do \
            mkdir -p /app/packages/"${package}" ; \
            cp -R \
                        /usr/src/peertube/packages/"${package}"/dist \
                        /usr/src/peertube/packages/"${package}"/package.json \
                    /app/packages/${package} ; \
        done ; \
        cp -R \
                    /usr/src/peertube/client/dist \
                    /usr/src/peertube/client/package.json \
                /app/client/ \
            ; \
        cp -R \
                    /usr/src/peertube/dist \
                    /usr/src/peertube/node_modules \
                    /usr/src/peertube/package.json \
                    /usr/src/peertube/yarn.lock \
                /app/ \
            ; \
    else \
        cp -R /usr/src/peertube/* /app ; \
    fi ; \
    \
    mkdir -p /container/data/peertube/config && \
    cp -R /usr/src/peertube/config/production.yaml.example /container/data/peertube/config && \
    chown -R peertube:peertube /app && \
    package remove \
                PEERTUBE_BUILD_DEPS \
                && \
    \
    package cleanup && \
    rm -rf /build-assets

EXPOSE 9000 1935

COPY rootfs/ /
