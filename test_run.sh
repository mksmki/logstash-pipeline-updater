#!/usr/bin/env bash

# ! Sandbox test values

docker run \
    --rm \
    -ti \
    --net netbox-docker_default \
    -e 'VAULT_URL=http://dev-vault:8200' \
    -e 'VAULT_TOKEN=hvs.GUvT7PAnGba4eNUpePdNERSO' \
    -e 'NETBOX_API=http://netbox:8080' \
    -e 'NETBOX_TOKEN=0123456789abcdef0123456789abcdef01234567' \
    -e 'ELASTIC_URL=http://elasticsearch:9000' \
    logstash-pipeline-updater:latest

    # --entrypoint /bin/bash \
    # -v "$(pwd)/ansible:/ansible" \
