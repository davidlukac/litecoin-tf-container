#!/usr/bin/env bash

# Download and verify binaries needed for the build.

set -xe

declare TERRAFORM_VER

# shellcheck source=.env
source .env

SRC="https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_386.zip"
SHA_SRC="https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_SHA256SUMS"
SIG_SRC="https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_SHA256SUMS.72D7468F.sig"

mkdir -p build

curl -sfLS "${SRC}" -o "build/terraform.zip"
curl -sfLS "${SHA_SRC}" -o build/terraform_sha256sums
curl -sfLS "${SIG_SRC}" -o build/terraform_sha256sums.sig

gpg --import resources/hashicorp.asc
gpg --verify build/terraform_sha256sums.sig build/terraform_sha256sums
grep linux_386 build/terraform_sha256sums | awk '{print $1 "  build/terraform.zip"}' | shasum -a 256 --check --strict

unzip build/terraform.zip -d build
chmod +x build/terraform

