#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug
exec ${SH_CMD} -- "$@"
