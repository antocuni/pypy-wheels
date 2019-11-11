# this file is meant to be sourced to get the *TAG env variables; the pwd MUST
# be the root of the repo

function _tag() {
    cat $(git ls-files $1) | md5sum | head -c 8
}

TAG=`_tag docker`
