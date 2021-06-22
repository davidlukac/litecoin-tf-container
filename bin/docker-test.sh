#!/usr/bin/env bash

# Perform formal checks, lint dockerfiles and check for security vulnerabilities.

set -xe

declare APP

# shellcheck source=.env
source .env

shellcheck bin/*.sh -x

hadolint Dockerfile

grype -q "sbom:./build/${APP}.sbom.json"
