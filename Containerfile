# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG BASE_IMAGE
ARG DISTRO
ARG DISTRO_VARIANT

FROM ${BASE_IMAGE}:${DISTRO}_${DISTRO_VARIANT}

LABEL \
        org.opencontainers.image.title="PeerTube" \
        org.opencontainers.image.description="Decntralized video hosting network" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/peertube" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-peertube/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-peertube.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    PEERTUBE_VERSION=v7.3.0 \
    PEERTUBE_REPO_URL="https://github.com/Chocobozzz/PeerTube" \
    PEERTUBE_CONTAINER=PRODUCTION \
    YQ_VERSION="v4.47.2" \
    YQ_REPO_URL="https://github.com/mikefarah/yq"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

#COPY build-assets /build-assets

ENV \
    PEERTUBE_CONTAINER=${PEERTUBE_CONTAINER:-"PRODUCTION"} \
    NGINX_ENABLE_APPLICATION_CONFIGURATION=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=peertube \
    NGINX_USER=peertube \
    NGINX_GROUP=peertube \
    IMAGE_NAME="tiredofit/peertube" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-peertube/"

RUN echo "" && \
    PEERTUBE_BUILD_DEPS_ALPINE=" \
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
    PEERTUBE_BUILD_DEPS_DEBIAN=" \
                                " \
                                && \
    PEERTUBE_RUN_DEPS_DEBIAN=" \
                                    ffmpeg \
                                    git \
                                    nodejs \
                                    postgresql-client \
                                    python3 \
                                    python3-pip \
                                    prosody \
                                    yarn \
                                " \
                                && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user peertube 1000 peertube 1000 /dev/null && \
    package repo key https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key nodesource.gpg && \
    package repo add nodejs "https://deb.nodesource.com/node_22.x nodistro main" nodesource.gpg && \
    package repo key https://www.postgresql.org/media/keys/ACCC4CF8.asc postgresql.gpg && \
    package repo add postgres "https://apt.postgresql.org/pub/repos/apt $(cat /etc/os-release | grep 'VERSION=' | awk 'NR>1{print $1}' RS='(' FS=')')-pgdg main" postgresql.gpg && \
    package repo key https://dl.yarnpkg.com/debian/pubkey.gpg yarn.gpg && \
    package repo add yarn "https://dl.yarnpkg.com/debian stable main" yarn.gpg && \
    package update && \
    package upgrade && \
    package install \
                    PEERTUBE_BUILD_DEPS \
                    PEERTUBE_RUN_DEPS \
                    && \
    \
    case $(container_info distro) in \
       debian ) \
            mkdir -p /usr/local/go ; \
            GOLANG_VERSION=${GOLANG_VERSION:-"$(curl -sSL https://golang.org/VERSION?m=text | head -n1 | sed "s|^go||g")"} ; \
            curl -sSLk https://dl.google.com/go/go${GOLANG_VERSION}.linux-$(container_info arch alt).tar.gz | tar xvfz - --strip 1 -C /usr/local/go ; \
            ln -sf /usr/local/go/bin/go /usr/local/bin/ ; \
            ln -sf /usr/local/go/bin/godoc /usr/local/bin/ ; \
            ln -sf /usr/local/go/bin/gfmt /usr/local/bin/ ;  \
            clone_git_repo \
                                "${YQ_REPO_URL}" \
                                "${YQ_VERSION}" \
                            /usr/src/yq && \
            \
            go build \
                        -ldflags "\
                                    -s \
                                    -w \
                                    -X github.com/mikefarah/yq/v4/version.Version=${YQ_VERSION} \
                                  " \
                        -o /usr/local/bin/yq \
                        && \
                container_build_log add "YQ" "${YQ_VERSION}" "${YQ_REPO_URL}" ; \
        ;; \
    esac ; \
    \
    clone_git_repo "${PEERTUBE_REPO_URL}" "${PEERTUBE_VERSION}" /usr/src/peertube && \
    build_assets src /usr/src/peertube && \
    build_assets scripts && \
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
        \
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
                /app/ \
                ; \
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
                    /app/packages/${package} \
                    ; \
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
    container_build_log add "PeerTube" "${PEERTUBE_VERSION}" "${PEERTUBE_REPO_URL}" && \
    package remove \
                    PEERTUBE_BUILD_DEPS \
                    && \
    \
    package cleanup && \
    rm -rf \
            /usr/local/bin/go \
            /usr/local/bin/godoc \
            /usr/local/bin/gfmt \
            /usr/local/go

EXPOSE 1935 9000

COPY rootfs/ /
