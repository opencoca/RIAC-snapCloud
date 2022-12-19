#!/bin/bash
# Version 1.2

# Copyright (c) Startr LLC. All rights reserved.
# This script is licensed under the GNU Affero General Public License v3.0.
# For more information, see https://www.gnu.org/licenses/agpl-3.0.en.html

# OpenCo™ Cocom Build 'n' Run Script

# This simple script builds and runs this directory 's Dockerfile Image
# Set PROJECTPATH to the path of the current directory
PROJECTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Set PROJECT to the lowercase version of the name of this directory
PROJECT=`echo ${PROJECTPATH##*/}|awk '{print tolower($0)}'`
# Set FULL_BRANCH to the name of the current Git branch
FULL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
# Set BRANCH to the lowercase version of this name, with everything after the last forward slash removed
BRANCH=${FULL_BRANCH##*/}
# Set TAG to the output of the git describe --always --tag command, which returns a "unique identifier" for the current commit
TAG=$(git describe --always --tag)

# Print the values of PROJECTPATH, PROJECT, FULL_BRANCH, and BRANCH to the console
echo PROJECTPATH=$PROJECTPATH
echo     PROJECT=$PROJECT
echo FULL_BRANCH=$FULL_BRANCH
echo      BRANCH=$BRANCH

# Build the Docker image using the docker build command, and tag it with the openco/$PROJECT-$BRANCH:$TAG tag
# Then tag the image with the openco/$PROJECT-$BRANCH:latest tag, and run the ./Run.sh script
echo docker build -t openco/$PROJECT-$BRANCH:$TAG .
echo docker tag -f openco/$PROJECT-$BRANCH:$TAG openco/$PROJECT-$BRANCH:latest
docker build -t openco/$PROJECT-$BRANCH:$TAG . \
  && \
docker tag openco/$PROJECT-$BRANCH:$TAG \
 openco/$PROJECT-$BRANCH:latest \
  && \
  #Run.sh
  docker run \
    -p 8888:8888 \
    -p 8080:8080 \
    -p:443:443 \
    -p 80:80 \
    -it openco/$PROJECT-$BRANCH:latest
