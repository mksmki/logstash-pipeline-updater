#!/usr/bin/env bash

docker run \
    -d \
    --name elasticsearch \
    --net netbox-docker_default \
    -p 9200:9200 \
    -p 9300:9300 \
    -e "xpack.security.transport.ssl.enabled=false" \
    -e "discovery.type=single-node" \
    -e "ELASTIC_PASSWORD=xxx" \
    elasticsearch:8.7.1

docker run \
    -d --name kibana \
    --net netbox-docker_default \
    -p 5601:5601 \
    -e 'ELASTICSEARCH_HOSTS=["http://elasticsearch:9200"]' \
    -e 'SERVER_NAME=kibana' \
    -e 'ELASTICSEARCH_USERNAME=kibana' \
    -e 'ELASTICSEARCH_PASSWORD=xxx' \
    kibana:8.7.1

docker run \
    -d \
    --name=grafana \
    --net netbox-docker_default \
    -p 3000:3000 \
    grafana/grafana:9.5.2
