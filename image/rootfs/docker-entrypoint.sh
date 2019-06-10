#!/bin/bash
set -e

source /docker-entrypoint-utils.sh
set_debug

if [[ "`id -u`" = "0" ]]; then
    chown ${PROJECT_JENKINS_USER}.root -R ${PROJECT_JENKINS_WORKSPACE}
fi

exec ${SH_CMD} -- "$@"
