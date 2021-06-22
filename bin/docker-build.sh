#!/usr/bin/env bash

# Build Litecoin-terraform Docker image.

set -xe

declare ALPINE_VER
declare APP
declare APP_VER
declare REPO_URL
declare TERRAFORM_VER

# shellcheck source=.env
source .env

BINARIES_DIR="./build"

# Re-download binary resources if folder doesn't exists or is empty.
if [ ! -d "${BINARIES_DIR}" ] || [ -z "$(ls -A ${BINARIES_DIR})" ] ; then
  bin/get-binaries.sh
fi

docker build \
  --build-arg "ALPINE_VER=${ALPINE_VER}" \
  --build-arg "APP=${APP}" \
  --build-arg "APP_VER=${APP_VER}" \
  --build-arg "TERRAFORM_VER=${TERRAFORM_VER}" \
  --no-cache \
  -f Dockerfile \
  -t "${REPO_URL}/${APP}:${APP_VER}" \
  .

# Generate BOM from the build image.
syft "${REPO_URL}/${APP}:${APP_VER}" --scope squashed -o json -q > "build/${APP}.sbom.json"
