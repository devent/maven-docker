#!/bin/bash
set -e

function setup_known_host() {
    ssh-keyscan ${PROJECT_SSH_HOST} >> ${PROJECT_SSH_HOME}/known_hosts
}

function setup_ssh() {
    echo "${PROJECT_SSH_ID_RSA}" > ${PROJECT_SSH_HOME}/id_rsa
    chmod go-rw ${PROJECT_SSH_HOME}/id_rsa
}

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

required_env=(
PROJECT_SSH_HOME
PROJECT_SSH_HOST
PROJECT_SSH_ID_RSA
PROJECT_SSH_USER
)

optional_env=(
PROJECT_SSH_PASS
)

for e in "${required_env[@]}"; do
    if [[ -z "${!e}" ]]; then
        echo "No ${e} set."
        exit 1
    fi
done

mkdir -p ${PROJECT_SSH_HOME}
setup_known_host
setup_ssh
