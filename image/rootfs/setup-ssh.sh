#!/bin/bash
set -e

function setup_known_host() {
    echo "${PROJECT_SSH_HOST}" >> ${PROJECT_SSH_HOME}/known_hosts
}

function setup_ssh() {
    echo "${PROJECT_SSH_ID_RSA}" > ${PROJECT_SSH_HOME}/id_rsa
    chmod go-rw ${PROJECT_SSH_HOME}/id_rsa
}

function setup_git() {
    git config --global user.email "${PROJECT_GIT_EMAIL}"
    git config --global user.name "${PROJECT_GIT_NAME}"
}

source /docker-entrypoint-utils.sh
set_debug

required_env=(
PROJECT_SSH_HOME
PROJECT_SSH_HOST
PROJECT_SSH_ID_RSA
PROJECT_SSH_USER
PROJECT_GIT_NAME
PROJECT_GIT_EMAIL
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
setup_git
