ARG APP_UID=1000
ARG APP_GID=1000

# :: Util
  FROM 11notes/util AS util

# :: Build
  FROM alpine AS build
  ARG TARGETARCH
  ARG APP_VERSION
  ARG APP_VERSION_BUILD
  ENV BUILD_ROOT=/Prowlarr
  ENV BUILD_BIN=${BUILD_ROOT}/Prowlarr
  USER root

  COPY --from=util /usr/local/bin/ /usr/local/bin

  RUN set -ex; \
    apk --update --no-cache add \
      curl \
      build-base \
      upx; \
    case "${TARGETARCH}" in \
      "amd64") \
        curl -SL https://github.com/Prowlarr/Prowlarr/releases/download/v${APP_VERSION}.${APP_VERSION_BUILD}/Prowlarr.master.${APP_VERSION}.${APP_VERSION_BUILD}.linux-musl-core-x64.tar.gz | tar -zxC /; \
      ;; \
      "arm64") \
        curl -SL https://github.com/Prowlarr/Prowlarr/releases/download/v${APP_VERSION}.${APP_VERSION_BUILD}/Prowlarr.master.${APP_VERSION}.${APP_VERSION_BUILD}.linux-musl-core-${TARGETARCH}.tar.gz | tar -zxC /; \
      ;; \
    esac; \
    eleven strip ${BUILD_BIN}; \
    find ${BUILD_ROOT} -type f -name '*.so' -exec strip -v {} &> /dev/null ';'; \
    mkdir -p /opt/prowlarr; \
    cp -R ${BUILD_ROOT}/* /opt/prowlarr; \
    rm -rf /opt/prowlarr/Prowlarr.Update;

# :: Header
  FROM 11notes/alpine:stable

  # :: arguments
    ARG TARGETARCH
    ARG APP_IMAGE
    ARG APP_NAME
    ARG APP_VERSION
    ARG APP_ROOT
    ARG APP_UID
    ARG APP_GID

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE}
    ENV APP_NAME=${APP_NAME}
    ENV APP_VERSION=${APP_VERSION}
    ENV APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=util --chown=${APP_UID}:${APP_GID} /usr/local/bin/ /usr/local/bin
    COPY --from=build --chown=${APP_UID}:${APP_GID} /opt/prowlarr /opt/prowlarr

# :: Run
  USER root

  # :: install applications
    RUN set -ex; \
      apk --no-cache --update add \
        icu-libs \
        sqlite-libs; \
      mkdir -p ${APP_ROOT}/etc;

  # :: copy filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R ${APP_UID}:${APP_GID} \
        ${APP_ROOT};

# :: Volumes
  VOLUME ["${APP_ROOT}/etc"]

# :: Monitor
  HEALTHCHECK --interval=5s --timeout=2s CMD ["/usr/bin/curl", "-kILs", "--fail", "-o", "/dev/null", "http://localhost:9696/ping"]

# :: Start
  USER ${APP_UID}:${APP_GID}