# nfrastack/container-peertube

## About

This will build a Docker Image for [Peertube](https://www.peertube.org/), a free and open-source, decentralized, ActivityPub federated video platform.

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents


* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
  * [Users and Groups](#users-and-groups)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/nfrastack/container-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Needs access to a Matrix Homeserver
*  Optional access to a Matrix Media Repository

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-peertube/pkgs/container/container-peertube) and [Docker Hub](https://hub.docker.com/r/nfrastack/peertube).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-peertube:(image_tag)
docker.io/nfrastack/peertube:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>`

Example:

`ghcr.io/nfrastack/container-peertube:latest` or

`ghcr.io/nfrastack/container-peertube:1.0` or

* `latest` will be the most recent commit
* An otpional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
* If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map persistent storage for access to configuration and data files for backup.
* Set various environment variables to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.


| Directory | Description         |
| --------- | ------------------- |
| `/config` | Configuration Files |
| `/data`   | Data                |
| `/logs`   | Logs                |

## Configuration

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description      |
| ------------------------------------------------------- | ---------------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image       |
| [Nginx](https://github.com/nfrastack/container-nginx/)  | Web Server Image |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

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

## Users and Groups

| Type  | Name    | ID    |
| ----- | ------- | ----- |
| User  | `argus` | 10000 |
| Group | `argus` | 10000 |

### Networking

| Port   | Protocol | Description |
| ------ | -------- | ----------- |
| `1935` | `tcp`    | RTSP        |
| `9000` | `tcp`    | Application |
* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

## Support & Maintenance

* For community help, tips, and community discussions, visit the Discussions board.
* For personalized support or a support agreement, see Nfrastack Support.
* To report bugs, submit a Bug Report. Usage questions will be closed as not-a-bug.
* Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
