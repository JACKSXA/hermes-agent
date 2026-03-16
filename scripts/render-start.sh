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

echo "[render-start] Starting Hermes gateway"
set +e
hermes gateway
status=$?
set -e

echo "[render-start] Hermes gateway exited with status ${status}"

if [[ -f "${HERMES_HOME}/gateway_state.json" ]]; then
  echo "[render-start] gateway_state.json"
  cat "${HERMES_HOME}/gateway_state.json"
fi

if [[ -f "${HERMES_HOME}/logs/gateway.log" ]]; then
  echo "[render-start] tail gateway.log"
  tail -n 200 "${HERMES_HOME}/logs/gateway.log"
fi

exit "${status}"
