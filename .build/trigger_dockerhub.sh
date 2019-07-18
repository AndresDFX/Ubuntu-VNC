#!/usr/bin/env bash
set -e -o pipefail


if [ -z $GIT_BRANCH ] ; then
    GIT_BRANCH=$TRAVIS_BRANCH
fi
if [ -z $GIT_BRANCH ] ; then
    echo "cloud not execute script! Please specify at least on environment variable of: GIT_BRANCH, TRAVIS_BRANCH"
    exit -1
fi

echo "branch=$GIT_BRANCH"
GIT_BRANCH=${GIT_BRANCH/origin\/}
DOCKER_TAG="${GIT_BRANCH/refs\/tags\/}"

if [[ $DOCKER_TAG == "master" ]] ; then
   echo "skip building latest tag!"
   echo "... use 'tag_image.sh' script to release a new version. See: https://github.com/AndresDFX/"
   exit 0
fi

echo "DOCKER_TAG=$DOCKER_TAG"
echo "..."
echo "trigger dockerhub builds for Tag $DOCKER_TAG:"

URLS=(

    "https://cloud.docker.com/api/build/v1/source/c0ea7c92-a75c-4202-80c9-fa4e1e2349ef/trigger/0831141e-0f79-456c-9a59-2a1685899795/call/"
)
PAYLOAD='{"source_type": "Tag", "source_name": "'$DOCKER_TAG'"}'

# use docker tag instead of branch
if [[ $DOCKER_TAG == "dev" ]] ; then
   PAYLOAD='{"docker_tag": "'dev'"}'
fi

# use first parameter to filter trigger command
IMAGENAME=$1

#Loop
for URL in "${URLS[@]}"
do
    if [ -z $IMAGENAME ] || [[ $URL =~ .*"$IMAGENAME".* ]] ; then
        echo "URL: $URL"
        echo "PAYLOAD: $PAYLOAD"
        curl -H "Content-Type: application/json" --data "$PAYLOAD" -X POST "$URL"
        echo " - done!"
    fi
done