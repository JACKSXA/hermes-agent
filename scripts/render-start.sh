#!/usr/bin/env bash
set -euo pipefail

export HERMES_HOME="${HERMES_HOME:-/var/data/.hermes}"
export MESSAGING_CWD="${MESSAGING_CWD:-/opt/render/project/src}"
export TERMINAL_ENV="${TERMINAL_ENV:-local}"

mkdir -p \
  "${HERMES_HOME}" \
  "${HERMES_HOME}/logs" \
  "${HERMES_HOME}/sessions" \
  "${HERMES_HOME}/skills"

touch "${HERMES_HOME}/.env"

cd /opt/render/project/src

exec hermes gateway
