#!/bin/bash

echo "Commit result..."
#set -v

# get SHA and EMAIL of the current revision
SHA=`git rev-parse --verify HEAD`
EMAIL=`git --no-pager show -s --format='<%ae>' HEAD`

# setup ssh auth
chmod 600 ./travis/travis.rsa
eval `ssh-agent -s`
ssh-add ./travis/travis.rsa

# commit to benchrepo
cd /tmp/gh-pages
REPO=`git config remote.origin.url`
TARGET_BRANCH=benchmarks
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}

git config push.default simple
git config user.email "$EMAIL"
git config user.name "Travis CI"

git add .
git commit -m "update index:
  - commit $SHA
  - travis job $TRAVIS_JOB_NUMBER
  - https://travis-ci.org/antocuni/pypy-wheels/jobs/$TRAVIS_JOB_ID
"
git push $SSH_REPO $TARGET_BRANCH

# workaround for this travis bug:
# https://github.com/travis-ci/travis-ci/issues/8082
ssh-agent -k
