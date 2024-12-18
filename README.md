# github.com/tiredofit/docker-peertube

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-peertube?style=flat-square)](https://github.com/tiredofit/docker-peertube/releases)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-peertube/build?style=flat-square)](https://github.com/tiredofit/docker-peertube/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/peertube.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/peertube/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/peertube.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/peertube/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [Peertube](https://www.peertube.org/), a free and open-source, decentralized, ActivityPub federated video platform.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Options](#options)
    - [Options](#options-1)
    - [Options](#options-2)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/peertube).

```
docker pull tiredofit/peertube:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/peertube/pkgs/container/peertube)

```
docker pull ghcr.io/tiredofit/docker-peertube:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Debian       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description         |
| --------- | ------------------- |
| `/config` | Configuration Files |
| `/data`   | Data                |
| `/logs`   | Logs                |


* * *
### Environment Variables

#### Base Images used

This image relies on an [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-debian/) | Customized Image based on Debian Linux |


#### Container Options
| Variable                                                | Description | Default                                            | `_FILE` |
| ------------------------------------------------------- | ----------- | -------------------------------------------------- | ------- |
| `DATA_PATH`                                             | Data Path   | `/data/`                                           |         |
| `LOG_PATH`                                              | Log Path    | `/logs/`                                           |         |
| `CONFIG_PATH`                                           |             | `/config/`                                         |         |
| `CONFIG_FILE`                                           |             | `production.yaml`                                  |         |
| `LISTEN_HOSTNAME`                                       |             | `0.0.0.0`                                          |         |
| `LISTEN_PORT`                                           |             | `9000`                                             |         |
| `LOG_PATH`                                              |             | `/logs/`                                           |         |
| `LOG_LEVEL`                                             |             | `info`                                             |         |
| `LOG_ANONYMIZE_IP`                                      |             | `false`                                            |         |
| `LOG_PING_REQUESTS`                                     |             | `true`                                             |         |
| `LOG_TRACKER_UNKNOWN_INFOHASH`                          |             | `true`                                             |         |
| `LOG_HTTP_REQUESTS`                                     |             | `false`                                            |         |
| `LOG_HTTP_REQUESTS`                                     |             | `true`                                             |         |
| `LOG_PRETTIFY_SQL`                                      |             | `false`                                            |         |
| `LOG_ACCEPT_CLIENT_LOGS`                                |             | `true`                                             |         |
| `DB_SUFFIX`                                             |             | ``                                                 |         |
| `DB_PORT`                                               |             | `5432`                                             |         |
| `DB_SSL`                                                |             | `false`                                            |         |
| `DB_POOL_MAX`                                           |             | `5`                                                |         |
| `REDIS_PORT`                                            |             | `6379`                                             |         |
| `REDIS_PASS`                                            |             | ``                                                 |         |
| `SMTP_HOST`                                             |             | `postfix-relay`                                    |         |
| `SMTP_PORT`                                             |             | `25`                                               |         |
| `SMTP_USER`                                             |             | ``                                                 |         |
| `SMTP_PASS`                                             |             | ``                                                 |         |
| `SMTP_TLS`                                              |             | `false`                                            |         |
| `SMTP_TLS_CA_FILE`                                      |             | ``                                                 |         |
| `SMTP_DISABLE_STARTTLS`                                 |             | `false`                                            |         |
| `SMTP_FROM`                                             |             | `admin@example.com`                                |         |
| `EMAIL_BODY_SIGNATURE`                                  |             | `PeerTube`                                         |         |
| `EMAIL_SUBJECT_PREFIX`                                  |             | `[PeerTube]`                                       |         |
| `DEFAULT_PUBLISH_ENABLE_DOWNLOAD`                       |             | `true`                                             |         |
| `DEFAULT_PUBLISH_COMMENTS_POLICY`                       |             | `1`                                                |         |
| `DEFAULT_PUBLISH_PRIVACY`                               |             | `1`                                                |         |
| `DEFAULT_PUBLISH_LICENSE`                               |             | ``                                                 |         |
| `DEFAULT_P2P_ENABLE_WEBAPP`                             |             | `true`                                             |         |
| `DEFAULT_P2P_ENABLE_EMBED`                              |             | `true`                                             |         |
| `STORAGE_TMP_PATH`                                      |             | `${DATA_PATH}/tmp/`                                |         |
| `STORAGE_TMP_PERSISTENT_PATH`                           |             | `${DATA_PATH}/tmp-persistent/`                     |         |
| `STORAGE_BIN_PATH`                                      |             | `${DATA_PATH}/bin/`                                |         |
| `STORAGE_AVATAR_PATH`                                   |             | `${DATA_PATH}/avatars/`                            |         |
| `STORAGE_WEB_VIDEOS_PATH`                               |             | `${DATA_PATH}/web-videos/`                         |         |
| `STORAGE_STREAMING_PLAYLISTS_PATH`                      |             | `${DATA_PATH}/streaming-playlists/`                |         |
| `STORAGE_ORIGINAL_VIDEO_PATH`                           |             | `${DATA_PATH}/original-video/`                     |         |
| `STORAGE_REDUNDANCY_PATH`                               |             | `${DATA_PATH}/redundancy/`                         |         |
| `STORAGE_PREVIEWS_PATH`                                 |             | `${DATA_PATH}/previews/`                           |         |
| `STORAGE_THUMBNAILS_PATH`                               |             | `${DATA_PATH}/thumbnails/`                         |         |
| `STORAGE_STORYBOARDS_PATH`                              |             | `${DATA_PATH}/storyboards/`                        |         |
| `STORAGE_TORRENTS_PATH`                                 |             | `${DATA_PATH}/torrents/`                           |         |
| `STORAGE_CAPTIONS_PATH`                                 |             | `${DATA_PATH}/captions/`                           |         |
| `STORAGE_CACHE_PATH`                                    |             | `${DATA_PATH}/cache/`                              |         |
| `STORAGE_PLUGINS_PATH`                                  |             | `${DATA_PATH}/plugins/`                            |         |
| `STORAGE_WELLKNOWN_PATH`                                |             | `${DATA_PATH}/well-known/`                         |         |
| `STORAGE_CLIENT_OVERRIDES_PATH`                         |             | `${DATA_PATH}/client-overrides/`                   |         |
| `ENABLE_TRACKER`                                        |             | `true`                                             |         |
| `TRACKER_REJECT_TOO_MANY_ANNOUNCES`                     |             | `true`                                             |         |
| `TRACKER_PRIVATE`                                       |             | `true`                                             |         |
| `RATELIMIT_LOGIN_WINDOW`                                |             | `5 minutes`                                        |         |
| `RATELIMIT_LOGIN_MAX`                                   |             | `15`                                               |         |
| `RATELIMIT_ASK_SEND_EMAIL_WINDOW`                       |             | `5 minutes`                                        |         |
| `RATELIMIT_ASK_SEND_EMAIL_MAX`                          |             | `3`                                                |         |
| `RATELIMIT_API_WINDOW`                                  |             | `10 seconds`                                       |         |
| `RATELIMIT_API_MAX`                                     |             | `50`                                               |         |
| `RATELIMIT_LOGIN_WINDOW`                                |             | `5 minutes`                                        |         |
| `RATELIMIT_LOGIN_MAX`                                   |             | `15`                                               |         |
| `RATELIMIT_SIGNUP_WINDOW`                               |             | `5 minutes`                                        |         |
| `RATELIMIT_SIGNUP_MAX`                                  |             | `3`                                                |         |
| `RATELIMIT_RECEIVE_CLIENT_LOG_WINDOW`                   |             | `1 minute`                                         |         |
| `RATELIMIT_RECEIVE_CLIENT_LOG_MAX`                      |             | `30`                                               |         |
| `RATELIMIT_PLUGINS_WINDOW`                              |             | `10 seconds`                                       |         |
| `RATELIMIT_PLUGINS_MAX`                                 |             | `200`                                              |         |
| `RATELIMIT_WELLKNOWN_WINDOW`                            |             | `10 seconds`                                       |         |
| `RATELIMIT_WELLKNOWN_MAX`                               |             | `200`                                              |         |
| `RATELIMIT_FEEDS_WINDOW`                                |             | `10 seconds`                                       |         |
| `RATELIMIT_FEEDS_MAX`                                   |             | `500`                                              |         |
| `RATELIMIT_ACTIVITYPUB_WINDOW`                          |             | `10 seconds`                                       |         |
| `RATELIMIT_ACTIVITYPUB_MAX`                             |             | `500`                                              |         |
| `RATELIMIT_CLIENT_WINDOW`                               |             | `10 seconds`                                       |         |
| `RATELIMIT_CLIENT_MAX`                                  |             | `500`                                              |         |
| `RATELIMIT_DOWNLOAD_GENERATE_VIDEO_WINDOW`              |             | `5 seconds`                                        |         |
| `RATELIMIT_DOWNLOAD_GENERATE_VIDEO_MAX`                 |             | `5`                                                |         |
| `REQUIRE_AUTH_PRIVATE_FILES`                            |             | `true`                                             |         |
| `ENABLE_OBJECT_STORAGE`                                 |             | `false`                                            |         |
| `OBJECT_STORAGE_MAX_UPLOAD_PART`                        |             | `100 MB`                                           |         |
| `OBJECT_STORAGE_MAX_REQUST_ATTEMPTS`                    |             | `3`                                                |         |
| `OBJECT_STORAGE_ENDPOINT`                               |             | ``                                                 |         |
| `OBJECT_STORAGE_REGION`                                 |             | `us-east-1`                                        |         |
| `OBJECT_STORAGE_UPLOADACL_PRIVATE`                      |             | `private`                                          |         |
| `OBJECT_STORAGE_UPLOADACL_PUBLIC`                       |             | `public-read`                                      |         |
| `OBJECT_STORAGE_PROXY_PRIVATE_FILES`                    |             | `true`                                             |         |
| `OBJECT_STORAGE_CREDENTIALS_ACCESS_KEY_ID`              |             | ``                                                 |         |
| `OBJECT_STORAGE_CREDENTIALS_SECRET_ACCESS_KEY`          |             | ``                                                 |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_BASE_URL`                |             | ``                                                 |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_BUCKET_NAME`             |             | `original-video-files`                             |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_PREFIX`                  |             | ``                                                 |         |
| `OBJECT_STORAGE_WEB_VIDEOS_BASE_URL`                    |             | ``                                                 |         |
| `OBJECT_STORAGE_WEB_VIDEOS_BUCKET_NAME`                 |             | `web-videos`                                       |         |
| `OBJECT_STORAGE_WEB_VIDEOS_PREFIX`                      |             | ``                                                 |         |
| `OBJECT_STORAGE_USER_EXPORTS_BASE_URL`                  |             | ``                                                 |         |
| `OBJECT_STORAGE_USER_EXPORTS_BUCKET_NAME`               |             | `user-exports`                                     |         |
| `OBJECT_STORAGE_USER_EXPORTS_PREFIX`                    |             | ``                                                 |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_BASE_URL`           |             | ``                                                 |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_BUCKET_NAME`        |             | `original-video-files`                             |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_PREFIX`             |             | ``                                                 |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_STORE_LIVE_STREAMS` |             | `true`                                             |         |
| `WEBSERVER_HTTPS`                                       |             | `false`                                            |         |
| `WEBSERVER_HOSTNAME`                                    |             | `example.com`                                      |         |
| `WEBSERVER_PORT`                                        |             | `443`                                              |         |
| `OAUTH2_TOKEN_LIFETIME_ACCESS`                          |             | `1 day`                                            |         |
| `OAUTH2_TOKEN_LIFETIME_REFRESH`                         |             | `2 weeks`                                          |         |
| `OPENTELEMETRY_METRICS_ENABLED`                         |             | `false`                                            |         |
| `OPENTELEMETRY_METRICS_PLAYBACK_STATS_INTERVAL`         |             | `15 seconds`                                       |         |
| `OPENTELEMETRY_METRICS_HTTP_REQUEST_DURATION_ENABLED`   |             | `false`                                            |         |
| `OPENTELEMETRY_METRICS_PROMETHEUS_EXPORTER_HOST`        |             | `127.0.0.1`                                        |         |
| `OPENTELEMETRY_METRICS_PROMETHEUS_EXPORTER_PORT`        |             | `9091`                                             |         |
| `OPENTELEMETRY_TRACING_ENABLED`                         |             | `false`                                            |         |
| `OPENTELEMETRY_TRACING_JAEGER_EXPORTER_ENDPOINT`        |             | ``                                                 |         |
| `TRENDING_VIDEOS_INTERVAL_DAYS`                         |             | `7`                                                |         |
| `TRENDING_VIDEOS_ALGORITHMS_ENABLED`                    |             | `hot,most-viewed,most-liked`                       |         |
| `TRENDING_VIDEOS_ALGORITHMS_DEFAULT`                    |             | `most-viewed`                                      |         |
| `REDUNDANCY_VIDEOS_CHECK_INTERVAL`                      |             | `1 hour`                                           |         |
| `REDUNDANCY_VIDEOS_STRATEGIES`                          |             | ``                                                 |         |
| `REMOTE_REDUNDANCY_VIDEOS_ACCEPT_FROM`                  |             | `anybody`                                          |         |
| `ENABLE_CSP`                                            |             | `false`                                            |         |
| `CSP_REPORT_ONLY`                                       |             | `true`                                             |         |
| `CSP_REPORT_URI`                                        |             | ``                                                 |         |
| `SECURITY_ENABLE_FRAMEGUARD`                            |             | `true`                                             |         |
| `SECURITY_ENABLE_POWERED_BY_HEADER`                     |             | `false`                                            |         |
| `ENABLE_FEDERATION`                                     |             | `true`                                             |         |
| `FEDERATION_PREVENT_SSRF`                               |             | `true`                                             |         |
| `FEDERATION_SIGN_FETCHES`                               |             | `true`                                             |         |
| `FEDERATION_VIDEOS_UNLISTED`                            |             | `false`                                            |         |
| `FEDERATION_VIDEOS_CLEANUP_REMOTE_INTERACTIONS`         |             | `true`                                             |         |
| `ENABLE_CHECK_LATEST_VERSION`                           |             | `false`                                            |         |
| `CHECK_LATEST_VERSION_URL`                              |             | `https://joinpeertube.org/api/v1/versions.json`    |         |
| `STATS_ENABLE_REGISTRATION_REQUESTS`                    |             | `true`                                             |         |
| `STATS_ENABLE_ABUSES`                                   |             | `true`                                             |         |
| `STATS_ENABLE_TOTAL_MODERATORS`                         |             | `true`                                             |         |
| `STATS_ENABLE_TOTAL_ADMINS`                             |             | `true`                                             |         |
| `TRUST_PROXY`                                           |             | `[\"127.0.0.1\", \"loopback\", \"172.16.0.0/12\"]` |         |

#### Options

| Variable | Description | Default | `_FILE` |
| -------- | ----------- | ------- | ------- |

#### Options

| Variable | Description | Default | `_FILE` |
| -------- | ----------- | ------- | ------- |

#### Options

| Variable | Description | Default | `_FILE` |
| -------- | ----------- | ------- | ------- |

### Networking

| Port   | Protocol | Description |
| ------ | -------- | ----------- |
| `1935` | `tcp`    | RTSP        |
| `9000` | `tcp`    | Application |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
