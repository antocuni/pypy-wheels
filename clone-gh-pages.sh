# clone the gh-pages branch
echo "Cloning gh-pages branch"

REPO=`git config remote.origin.url`
BRANCH=gh-pages
cd /tmp/
git clone --depth=1 --branch=$BRANCH $REPO gh-pages
