#!/bin/bash

echo "Commit result..."
#set -v

# get SHA and EMAIL of the current revision
SHA=`git rev-parse --verify HEAD`
EMAIL=`git --no-pager show -s --format='<%ae>' HEAD`

# setup ssh auth
if [ ! -e ./travis/travis.rsa ]
then
    echo "travis/travis.rsa does not exists (probably because this is a PR)"
    echo "exiting"
    exit
fi

chmod 600 ./travis/travis.rsa
eval `ssh-agent -s`
ssh-add ./travis/travis.rsa

cd /tmp/gh-pages
REPO=`git config remote.origin.url`
TARGET_BRANCH=gh-pages
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}

git config push.default simple
git config user.email "$EMAIL"
git config user.name "Travis CI"

# the following is unsafe, there are race conditions: if two jobs try to
# commit at the same time, the second cannot push because it creates another
# head. Solving it completely is not easy because the html files conflicts. To
# mitigate the problem, we do a git pull immediately before the commit
git pull

git add .
git status
git commit -m "update index:
  - commit $SHA
  - travis job $TRAVIS_JOB_NUMBER
  - https://travis-ci.org/antocuni/pypy-wheels/jobs/$TRAVIS_JOB_ID
"

# https://graysonkoonce.com/getting-the-current-branch-name-during-a-pull-request-in-travis-ci/
TR_BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}
echo "current git branch: $TR_BRANCH"
if [ "$TR_BRANCH" == "master" ]
then
    echo "pushing changes to $SSH_REPO"
    git push $SSH_REPO $TARGET_BRANCH
    EXIT_CODE=$?
else
    echo "NOT pushing, since it's not master"
    EXIT_CODE=0
fi

# workaround for this travis bug:
# https://github.com/travis-ci/travis-ci/issues/8082
ssh-agent -k

exit $EXIT_CODE
