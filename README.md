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

| Variable          | Description                         | Default           | `_FILE` |
| ----------------- | ----------------------------------- | ----------------- | ------- |
| `DATA_PATH`       | Path for persistent data storage    | `/data/`          |         |
| `LOG_PATH`        | Path for log files                  | `/logs/`          |         |
| `CONFIG_PATH`     | Path for configuration files        | `/config/`        |         |
| `CONFIG_FILE`     | Name of the main configuration file | `production.yaml` |         |
| `LISTEN_HOSTNAME` | Hostname for PeerTube to listen on  | `0.0.0.0`         |         |
| `LISTEN_PORT`     | Port for PeerTube to listen on      | `9000`            |         |

#### Log Options

| Variable                       | Description                              | Default  | `_FILE` |
| ------------------------------ | ---------------------------------------- | -------- | ------- |
| `LOG_PATH`                     | Path for log files                       | `/logs/` |         |
| `LOG_LEVEL`                    | Log level: debug, info, warn, error      | `info`   |         |
| `LOG_ANONYMIZE_IP`             | Anonymize IP addresses in logs           | `false`  |         |
| `LOG_PING_REQUESTS`            | Log ping requests                        | `true`   |         |
| `LOG_TRACKER_UNKNOWN_INFOHASH` | Log unknown infohash requests to tracker | `true`   |         |
| `LOG_HTTP_REQUESTS`            | Log HTTP requests                        | `false`  |         |
| `LOG_HTTP_REQUESTS`            | Log HTTP requests                        | `true`   |         |
| `LOG_PRETTIFY_SQL`             | Prettify SQL queries in logs             | `false`  |         |
| `LOG_ACCEPT_CLIENT_LOGS`       | Accept warn/error logs from client       | `true`   |         |

#### DB Options

| Variable      | Description                                    | Default | `_FILE` |
| ------------- | ---------------------------------------------- | ------- | ------- |
| `DB_SUFFIX`   | Suffix for database name                       | ``      |         |
| `DB_PORT`     | Database port                                  | `5432`  |         |
| `DB_SSL`      | Use SSL for database connection                | `false` |         |
| `DB_POOL_MAX` | Maximum number of database connections in pool | `5`     |         |
| `REDIS_PORT`  | Redis server port                              | `6379`  |         |
| `REDIS_PASS`  | Redis password                                 | ``      |         |

#### Mail Options

| Variable                | Description                                      | Default             | `_FILE` |
| ----------------------- | ------------------------------------------------ | ------------------- | ------- |
| `SMTP_HOST`             | SMTP server hostname                             | `postfix-relay`     |         |
| `SMTP_PORT`             | SMTP server port                                 | `25`                |         |
| `SMTP_USER`             | SMTP username                                    | ``                  |         |
| `SMTP_PASS`             | SMTP password                                    | ``                  |         |
| `SMTP_TLS`              | Enable TLS for SMTP                              | `false`             |         |
| `SMTP_TLS_CA_FILE`      | CA file for self-signed SMTP certificates        | ``                  |         |
| `SMTP_DISABLE_STARTTLS` | Disable STARTTLS for SMTP                        | `false`             |         |
| `SMTP_FROM`             | Email address for outgoing emails                | `admin@example.com` |         |
| `EMAIL_BODY_SIGNATURE`  | Email signature (supports {{instanceName}})      | `PeerTube`          |         |
| `EMAIL_SUBJECT_PREFIX`  | Email subject prefix (supports {{instanceName}}) | `[PeerTube]`        |         |


#### Storage Options

| Variable                                                | Description                                           | Default                             | `_FILE` |
| ------------------------------------------------------- | ----------------------------------------------------- | ----------------------------------- | ------- |
| `STORAGE_TMP_PATH`                                      | Path for temporary storage                            | `${DATA_PATH}/tmp/`                 |         |
| `STORAGE_TMP_PERSISTENT_PATH`                           | Path for persistent temporary storage                 | `${DATA_PATH}/tmp-persistent/`      |         |
| `STORAGE_BIN_PATH`                                      | Path for binary storage                               | `${DATA_PATH}/bin/`                 |         |
| `STORAGE_AVATAR_PATH`                                   | Path for avatar images                                | `${DATA_PATH}/avatars/`             |         |
| `STORAGE_WEB_VIDEOS_PATH`                               | Path for web-compatible videos                        | `${DATA_PATH}/web-videos/`          |         |
| `STORAGE_STREAMING_PLAYLISTS_PATH`                      | Path for streaming playlists                          | `${DATA_PATH}/streaming-playlists/` |         |
| `STORAGE_ORIGINAL_VIDEO_PATH`                           | Path for original video files                         | `${DATA_PATH}/original-video/`      |         |
| `STORAGE_REDUNDANCY_PATH`                               | Path for redundancy storage                           | `${DATA_PATH}/redundancy/`          |         |
| `STORAGE_PREVIEWS_PATH`                                 | Path for video previews                               | `${DATA_PATH}/previews/`            |         |
| `STORAGE_THUMBNAILS_PATH`                               | Path for video thumbnails                             | `${DATA_PATH}/thumbnails/`          |         |
| `STORAGE_STORYBOARDS_PATH`                              | Path for video storyboards                            | `${DATA_PATH}/storyboards/`         |         |
| `STORAGE_TORRENTS_PATH`                                 | Path for video torrents                               | `${DATA_PATH}/torrents/`            |         |
| `STORAGE_CAPTIONS_PATH`                                 | Path for video captions                               | `${DATA_PATH}/captions/`            |         |
| `STORAGE_CACHE_PATH`                                    | Path for cache storage                                | `${DATA_PATH}/cache/`               |         |
| `STORAGE_PLUGINS_PATH`                                  | Path for plugins                                      | `${DATA_PATH}/plugins/`             |         |
| `STORAGE_WELLKNOWN_PATH`                                | Path for .well-known files                            | `${DATA_PATH}/well-known/`          |         |
| `STORAGE_UPLOADS_PATH`                                  | Path for uploads                                      | `${DATA_PATH}/uploads/`             |         |
| `STORAGE_CLIENT_OVERRIDES_PATH`                         | Path for client override files                        | `${DATA_PATH}/client-overrides/`    |         |
| `ENABLE_OBJECT_STORAGE`                                 | Enable object storage (S3, etc.)                      | `false`                             |         |
| `OBJECT_STORAGE_MAX_UPLOAD_PART`                        | Max upload part size for object storage               | `100MB`                             |         |
| `OBJECT_STORAGE_MAX_REQUST_ATTEMPTS`                    | Max request attempts to object storage                | `3`                                 |         |
| `OBJECT_STORAGE_ENDPOINT`                               | Object storage endpoint                               | ``                                  |         |
| `OBJECT_STORAGE_REGION`                                 | Object storage region                                 | `us-east-1`                         |         |
| `OBJECT_STORAGE_UPLOADACL_PRIVATE`                      | ACL for private uploads to object storage             | `private`                           |         |
| `OBJECT_STORAGE_UPLOADACL_PUBLIC`                       | ACL for public uploads to object storage              | `public-read`                       |         |
| `OBJECT_STORAGE_PROXY_PRIVATE_FILES`                    | Proxy private files from object storage               | `true`                              |         |
| `OBJECT_STORAGE_CREDENTIALS_ACCESS_KEY_ID`              | Object storage access key ID                          | ``                                  |         |
| `OBJECT_STORAGE_CREDENTIALS_SECRET_ACCESS_KEY`          | Object storage secret access key                      | ``                                  |         |
| `OBJECT_STORAGE_CAPTIONS_BASE_URL`                      | Base URL for captions in object storage               | ``                                  |         |
| `OBJECT_STORAGE_CAPTIONS_BUCKET_NAME`                   | Bucket name for captions in object storage            | `captions`                          |         |
| `OBJECT_STORAGE_CAPTIONS_PREFIX`                        | Prefix for captions in object storage                 | ``                                  |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_BASE_URL`                | Base URL for original videos in object storage        | ``                                  |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_BUCKET_NAME`             | Bucket name for original videos in object storage     | `original-video-files`              |         |
| `OBJECT_STORAGE_ORIGINAL_VIDEO_PREFIX`                  | Prefix for original videos in object storage          | ``                                  |         |
| `OBJECT_STORAGE_WEB_VIDEOS_BASE_URL`                    | Base URL for web videos in object storage             | ``                                  |         |
| `OBJECT_STORAGE_WEB_VIDEOS_BUCKET_NAME`                 | Bucket name for web videos in object storage          | `web-videos`                        |         |
| `OBJECT_STORAGE_WEB_VIDEOS_PREFIX`                      | Prefix for web videos in object storage               | ``                                  |         |
| `OBJECT_STORAGE_USER_EXPORTS_BASE_URL`                  | Base URL for user exports in object storage           | ``                                  |         |
| `OBJECT_STORAGE_USER_EXPORTS_BUCKET_NAME`               | Bucket name for user exports in object storage        | `user-exports`                      |         |
| `OBJECT_STORAGE_USER_EXPORTS_PREFIX`                    | Prefix for user exports in object storage             | ``                                  |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_BASE_URL`           | Base URL for streaming playlists in object storage    | ``                                  |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_BUCKET_NAME`        | Bucket name for streaming playlists in object storage | `original-video-files`              |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_PREFIX`             | Prefix for streaming playlists in object storage      | ``                                  |         |
| `OBJECT_STORAGE_STREAMING_PLAYLISTS_STORE_LIVE_STREAMS` | Store live streams in object storage                  | `true`                              |         |

#### Security Options

| Variable                                   | Description                                     | Default                                            | `_FILE` |
| ------------------------------------------ | ----------------------------------------------- | -------------------------------------------------- | ------- |
| `ENABLE_CSP`                               | Enable Content Security Policy                  | `false`                                            |         |
| `CSP_REPORT_ONLY`                          | Enable CSP report-only mode                     | `true`                                             |         |
| `CSP_REPORT_URI`                           | URI for CSP violation reports                   | ``                                                 |         |
| `SECURITY_ENABLE_FRAMEGUARD`               | Enable X-Frame-Options header                   | `true`                                             |         |
| `SECURITY_ENABLE_POWERED_BY_HEADER`        | Enable x-powered-by PeerTube header             | `false`                                            |         |
| `TRUST_PROXY`                              | Proxies to trust for real client IP             | `[\"127.0.0.1\", \"loopback\", \"172.16.0.0/12\"]` |         |
| `RATELIMIT_LOGIN_WINDOW`                   | Rate limit window for login attempts            | `5 minutes`                                        |         |
| `RATELIMIT_LOGIN_MAX`                      | Max login attempts per window                   | `15`                                               |         |
| `RATELIMIT_ASK_SEND_EMAIL_WINDOW`          | Rate limit window for send email requests       | `5 minutes`                                        |         |
| `RATELIMIT_ASK_SEND_EMAIL_MAX`             | Max send email requests per window              | `3`                                                |         |
| `RATELIMIT_API_WINDOW`                     | Rate limit window for API requests              | `10 seconds`                                       |         |
| `RATELIMIT_API_MAX`                        | Max API requests per window                     | `50`                                               |         |
| `RATELIMIT_LOGIN_WINDOW`                   | Rate limit window for login attempts            | `5 minutes`                                        |         |
| `RATELIMIT_LOGIN_MAX`                      | Max login attempts per window                   | `15`                                               |         |
| `RATELIMIT_SIGNUP_WINDOW`                  | Rate limit window for signup attempts           | `5 minutes`                                        |         |
| `RATELIMIT_SIGNUP_MAX`                     | Max signup attempts per window                  | `3`                                                |         |
| `RATELIMIT_RECEIVE_CLIENT_LOG_WINDOW`      | Rate limit window for client log submissions    | `1 minute`                                         |         |
| `RATELIMIT_RECEIVE_CLIENT_LOG_MAX`         | Max client log submissions per window           | `30`                                               |         |
| `RATELIMIT_PLUGINS_WINDOW`                 | Rate limit window for plugin requests           | `10 seconds`                                       |         |
| `RATELIMIT_PLUGINS_MAX`                    | Max plugin requests per window                  | `200`                                              |         |
| `RATELIMIT_WELLKNOWN_WINDOW`               | Rate limit window for .well-known requests      | `10 seconds`                                       |         |
| `RATELIMIT_WELLKNOWN_MAX`                  | Max .well-known requests per window             | `200`                                              |         |
| `RATELIMIT_FEEDS_WINDOW`                   | Rate limit window for feeds                     | `10 seconds`                                       |         |
| `RATELIMIT_FEEDS_MAX`                      | Max feed requests per window                    | `500`                                              |         |
| `RATELIMIT_ACTIVITYPUB_WINDOW`             | Rate limit window for ActivityPub requests      | `10 seconds`                                       |         |
| `RATELIMIT_ACTIVITYPUB_MAX`                | Max ActivityPub requests per window             | `500`                                              |         |
| `RATELIMIT_CLIENT_WINDOW`                  | Rate limit window for client HTML requests      | `10 seconds`                                       |         |
| `RATELIMIT_CLIENT_MAX`                     | Max client HTML requests per window             | `500`                                              |         |
| `RATELIMIT_DOWNLOAD_GENERATE_VIDEO_WINDOW` | Rate limit window for video download generation | `5 seconds`                                        |         |
| `RATELIMIT_DOWNLOAD_GENERATE_VIDEO_MAX`    | Max video download generations per window       | `5`                                                |         |


#### Statistics / Telemetry Options

| Variable                                              | Description                          | Default      | `_FILE` |
| ----------------------------------------------------- | ------------------------------------ | ------------ | ------- |
| `OPENTELEMETRY_METRICS_ENABLED`                       | Enable OpenTelemetry metrics         | `false`      |         |
| `OPENTELEMETRY_METRICS_PLAYBACK_STATS_INTERVAL`       | Playback stats interval for metrics  | `15 seconds` |         |
| `OPENTELEMETRY_METRICS_HTTP_REQUEST_DURATION_ENABLED` | Enable HTTP request duration metric  | `false`      |         |
| `OPENTELEMETRY_METRICS_PROMETHEUS_EXPORTER_HOST`      | Prometheus exporter hostname         | `127.0.0.1`  |         |
| `OPENTELEMETRY_METRICS_PROMETHEUS_EXPORTER_PORT`      | Prometheus exporter port             | `9091`       |         |
| `OPENTELEMETRY_TRACING_ENABLED`                       | Enable OpenTelemetry tracing         | `false`      |         |
| `OPENTELEMETRY_TRACING_JAEGER_EXPORTER_ENDPOINT`      | Jaeger exporter endpoint for tracing | ``           |         |
| `STATS_ENABLE_REGISTRATION_REQUESTS`                  | Enable registration requests stats   | `true`       |         |
| `STATS_ENABLE_ABUSES`                                 | Enable abuses stats                  | `true`       |         |
| `STATS_ENABLE_TOTAL_MODERATORS`                       | Enable total moderators stats        | `true`       |         |
| `STATS_ENABLE_TOTAL_ADMINS`                           | Enable total admins stats            | `true`       |         |

#### Application Options

| Variable                                        | Description                                    | Default                                         | `_FILE` |
| ----------------------------------------------- | ---------------------------------------------- | ----------------------------------------------- | ------- |
| `DEFAULT_PUBLISH_ENABLE_DOWNLOAD`               | Default: allow video downloads                 | `true`                                          |         |
| `DEFAULT_PUBLISH_COMMENTS_POLICY`               | Default comments policy for new videos         | `1`                                             |         |
| `DEFAULT_PUBLISH_PRIVACY`                       | Default privacy for new videos                 | `1`                                             |         |
| `DEFAULT_PUBLISH_LICENSE`                       | Default license for new videos                 | ``                                              |         |
| `DEFAULT_P2P_ENABLE_WEBAPP`                     | Enable P2P by default in PeerTube client       | `true`                                          |         |
| `DEFAULT_P2P_ENABLE_EMBED`                      | Enable P2P by default in PeerTube embed        | `true`                                          |         |
| `ENABLE_TRACKER`                                | Enable PeerTube P2P tracker                    | `true`                                          |         |
| `TRACKER_REJECT_TOO_MANY_ANNOUNCES`             | Reject peers with too many announces           | `true`                                          |         |
| `TRACKER_PRIVATE`                               | Only handle requests on your videos            | `true`                                          |         |
| `REQUIRE_AUTH_PRIVATE_FILES`                    | Require authentication for private files       | `true`                                          |         |
| `OAUTH2_TOKEN_LIFETIME_ACCESS`                  | OAuth2 access token lifetime                   | `1 day`                                         |         |
| `OAUTH2_TOKEN_LIFETIME_REFRESH`                 | OAuth2 refresh token lifetime                  | `2 weeks`                                       |         |
| `TRENDING_VIDEOS_INTERVAL_DAYS`                 | Number of days for trending video calculation  | `7`                                             |         |
| `TRENDING_VIDEOS_ALGORITHMS_ENABLED`            | Enabled trending algorithms                    | `hot,most-viewed,most-liked`                    |         |
| `TRENDING_VIDEOS_ALGORITHMS_DEFAULT`            | Default trending algorithm                     | `most-viewed`                                   |         |
| `REDUNDANCY_VIDEOS_CHECK_INTERVAL`              | Interval for checking new videos to cache      | `1 hour`                                        |         |
| `REDUNDANCY_VIDEOS_STRATEGIES`                  | Strategies for video redundancy                | ``                                              |         |
| `REMOTE_REDUNDANCY_VIDEOS_ACCEPT_FROM`          | Accept remote redundancies from                | `anybody`                                       |         |
| `ENABLE_FEDERATION`                             | Enable ActivityPub federation                  | `true`                                          |         |
| `FEDERATION_PREVENT_SSRF`                       | Prevent SSRF requests in federation            | `true`                                          |         |
| `FEDERATION_SIGN_FETCHES`                       | Sign federated fetches                         | `true`                                          |         |
| `FEDERATION_VIDEOS_UNLISTED`                    | Federate unlisted videos                       | `false`                                         |         |
| `FEDERATION_VIDEOS_CLEANUP_REMOTE_INTERACTIONS` | Cleanup remote AP interactions on local videos | `true`                                          |         |
| `ENABLE_CHECK_LATEST_VERSION`                   | Enable check for latest PeerTube version       | `false`                                         |         |
| `CHECK_LATEST_VERSION_URL`                      | URL for checking latest PeerTube version       | `https://joinpeertube.org/api/v1/versions.json` |         |

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
