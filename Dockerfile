FROM    oraclelinux:8

ARG     version="0.7"
ARG     username="ansible"
ARG     group="ansible"

LABEL   name='logstash-pipeline-updater'
LABEL   maintainer='Network Observability & Automation Group'
LABEL   desription='Logstash Dynamic Pipeline Updater'
LABEL   version='${version}'

ENV     LANG=en_US.utf8
ENV     RUN_INTERVAL="30"
ENV     WORKDIR=/ansible

# URLs and API Keys/Tokens
ENV     VAULT_URL=""
ENV     VAULT_TOKEN=""
ENV     NETBOX_API=""
ENV     NETBOX_TOKEN=""
ENV     ELASTIC_URL=""
ENV     PIPELINE_ID=""

USER root

RUN \
    dnf -y update && \
    dnf -y install \
        ansible-core-2.13.3 \
        python39-3.9.13 \
        python39-cffi-1.14.3 \
        python39-cryptography-3.3.1 \
        python39-idna-2.10 \
        python39-pycparser-2.20 \
        python39-requests-2.25.0 \
        python39-urllib3-1.25.10 \
        git-core-2.31.1 \
        less-530 \
        python39-chardet-3.0.4 \
        python39-libs-3.9.13 \
        python39-pip-wheel-20.2.4 \
        python39-ply-3.11 \
        python39-pysocks-1.7.1 \
        python39-pyyaml-5.4.1 \
        python39-setuptools-50.3.2 \
        python39-setuptools-wheel-50.3.2 \
        python39-six-1.15.0 \
        sshpass-1.09 \
        python39-pip-20.2.4 \
        && \
    ansible --version && \
    dnf clean all && \
    rm -rf /var/cache/dnf && \
    echo "[$(date)] OS packages installation complete"

# Copy pre-downloaded packages
COPY files/* /tmp/

# Container image payload
RUN \
    cd /tmp/ && \
    pip3 install -r requirements.txt && \
    ansible-galaxy collection install \
        --collections-path /usr/share/ansible/collections \
        'netbox.netbox:==3.13.0' \
        'community.hashi_vault:==5.0.0' \
        && \
    echo "[$(date) Build Phase 1 complete]"

# COPY    docker/start.sh /start.sh
COPY    docker/entry.sh /entry.sh

RUN \
    chmod 0755 /entry.sh && \
    mkdir ${WORKDIR} && \
    chmod 0755 ${WORKDIR} && \
    groupadd ${group} && \
    useradd \
        --no-create-home \
        --home-dir ${WORKDIR} \
        --comment "Service account for application" \
        --gid ${group} \
        --shell /bin/bash \
        ${username} && \
    chown ${username}:${group} -R ${WORKDIR} && \
    echo "[$(date) Build Phase 2 complete]"

COPY    --chown=${username}:${group} ansible/ ${WORKDIR}/

# To avoid execution with root privileges
# USER    ${username}

WORKDIR ${WORKDIR}
# VOLUME [ "${WORKDIR}" ]
ENTRYPOINT [ "/entry.sh" ]
# CMD [ "/start.sh" ]
