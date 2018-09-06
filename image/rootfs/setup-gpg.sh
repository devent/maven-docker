#!/bin/bash
set -e

function setup_gpg() {
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "use-agent" >> ~/.gnupg/gpg.conf
    echo "pinentry-mode loopback" >> ~/.gnupg/gpg.conf
    echo "allow-loopback-pinentry" >> ~/.gnupg/gpg-agent.conf
    echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf
    echo RELOADAGENT | gpg-connect-agent
    echo "${GPG_PASSPHRASE}" | base64 -d | gpg --passphrase-fd 0 --allow-secret-key-import --import ${GPG_KEY_FILE}
}

function sign_cache_gpg() {
    echo "document" > doc
    echo "${GPG_PASSPHRASE}" | base64 -d | gpg --no-tty --batch --passphrase-fd 0 --output doc.sig --sign doc
    rm doc
    rm doc.sig
}

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

if [[ -z "${GPG_PASSPHRASE}" ]]; then
    echo "No GPG_PASSPHRASE set."
    exit 1
fi

if [[ -z "${GPG_KEY_FILE}" ]]; then
    echo "No GPG_KEY_FILE set."
    exit 1
fi

setup_gpg
sign_cache_gpg
