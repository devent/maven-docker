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
    tmp=`mktemp doc.XXXXX`
    trap "rm -f ${tmp}; rm -f ${tmp}.sig || true;" EXIT
    echo "document" > ${tmp}
    echo "${GPG_PASSPHRASE}" | base64 -d | gpg --no-tty --batch --passphrase-fd 0 --output ${tmp}.sig --sign ${tmp}
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

/setup.sh
setup_gpg
sign_cache_gpg
