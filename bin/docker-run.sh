#!/usr/bin/env bash

# Run the litecoin-tf container with mounted sources.

set -xe

declare APP

# shellcheck source=.env
source .env

docker run \
  --rm \
  -it \
  --name "${APP}" \
  -v "$(pwd)/":/opt/app \
  "${REPO_URL}/${APP}:${APP_VER}"
