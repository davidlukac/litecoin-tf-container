ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

# Arguments that should be available during the build must be declared after FROM statement.
ARG ALPINE_VER
ARG APP
ARG APP_VER
ARG TERRAFORM_VER

# Maintainer and version metadata.
ENV ALPINE_VER=${ALPINE_VER} \
    APP=${APP} \
    APP_VER=${APP_VER} \
    TERRAFORM_VER=${TERRAFORM_VER}

LABEL org.opencontainers.image.authors="davidlukac@users.noreply.github.com" \
      org.opencontainers.image.version=${APP_VER} \
      version=${APP_VER} \
      application=${APP} \
      alpine-version=${ALPINE_VER} \
      terraform-version=${TERRAFORM_VER}

RUN apk --update add --no-progress --no-cache \
      curl=7.77.0-r1 \
      git=2.30.2-r0 \
      terraform=0.14.4-r0 && \
    rm -rf /var/cache/apk/*

# Overwrite terraform binary with newer downloaded version.
COPY build/terraform /usr/bin/terraform

RUN ln -s /usr/bin/terraform /usr/bin/tf && \
    adduser -u 1001 -D terraform && \
    mkdir -p /opt/app && \
    chown -R terraform:terraform /opt/app

USER terraform
WORKDIR /opt/app
