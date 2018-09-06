#!/bin/bash
set -e

function setup_known_host() {
    ssh-keyscan ${SSH_HOST} >> ${SSH_HOME}/known_hosts
}

function setup_ssh() {
    cp ${SSH_FILE} ${SSH_HOME}/id_rsa
    chmod go-rw ${SSH_HOME}/id_rsa
}

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

needed_env=(
SSH_HOME
SSH_HOST
SSH_FILE
SSH_USER
SSH_PASS
)

for e in "${needed_env[@]}"; do
    if [[ -z "${!e}" ]]; then
        echo "No ${e} set."
        exit 1
    fi
done

setup_known_host
setup_ssh
