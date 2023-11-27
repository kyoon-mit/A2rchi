#!/bin/bash

# create volume if it doesn't already exist
exists=`docker volume ls | awk '{print $2}' | grep a2rchi-prod-meta-data`
if [[ $exists != 'a2rchi-prod-meta-data' ]]; then
    docker volume create --name a2rchi-prod-meta-data
fi

# build base image; try to reuse previously built image
cd A2rchi-prod-meta/deploy/prod-meta/
docker build -f ../dockerfiles/Dockerfile-base -t a2rchi-base:BASE_TAG ../..

# start services
echo "Starting docker compose"
docker compose -f prod-meta-compose.yaml up -d --build --force-recreate --always-recreate-deps

# # secrets files are created by CI pipeline and destroyed here
# rm secrets/*.txt
