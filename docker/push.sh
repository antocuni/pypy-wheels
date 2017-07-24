export DOCKER_ID_USER="antocuni"
#docker login -u $DOCKER_ID_USER

docker tag pypy-wheels $DOCKER_ID_USER/pypy-wheels
docker push $DOCKER_ID_USER/pypy-wheels
