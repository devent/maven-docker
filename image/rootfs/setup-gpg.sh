#!/bin/bash
set -e

function setup_gpg() {
    tmp=`mktemp out.XXXXX`
    trap "rm -f ${tmp}; rm -f ${tmp}.sig || true;" EXIT
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    echo "use-agent" >> ~/.gnupg/gpg.conf
    echo "allow-preset-passphrase" >> ~/.gnupg/gpg-agent.conf
    eval $(gpg-agent --daemon)
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

function preset_passphrase() {
    echo "${GPG_PASSPHRASE}" | base64 -d | /usr/libexec/gpg-preset-passphrase -c ${GPG_KEY_ID}
}

function test_sign_gpg() {
    tmp=`mktemp doc.XXXXX`
    trap "rm -f ${tmp}; rm -f ${tmp}.sig || true;" EXIT
    echo "document" > ${tmp}
    gpg --use-agent --no-tty --output ${tmp}.sig --sign ${tmp}
}

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

required_env=(
GPG_PASSPHRASE
GPG_KEY_FILE
GPG_KEY_ID
)

for e in "${required_env[@]}"; do
    if [[ -z "${!e}" ]]; then
        echo "No ${e} set."
        exit 1
    fi
done

/setup.sh
setup_gpg
preset_passphrase
test_sign_gpg
