#!/bin/bash
set -e

function setup_gpg() {
    tmp=`mktemp out.XXXXX`
    trap "rm -f ${tmp}; rm -f ${tmp}.sig || true;" EXIT
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "use-agent" >> ~/.gnupg/gpg.conf
    echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf
    set +e
    echo "${GPG_PASSPHRASE}" | base64 -d | gpg --passphrase-fd 0 --allow-secret-key-import --import ${GPG_KEY_FILE} > ${tmp} 2>&1
    set -e
    ret=$?
    cat $tmp
    if [[ $ret -ne 0 ]]; then
        if grep 'already in secret keyring' ${tmp}; then
            ret=0
        fi
    fi
    return $ret
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
