FROM    oraclelinux:8

ARG     version="0.5"
ARG     username="ansible"
ARG     group="ansible"

LABEL   name='logstash-config-updater'
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

# pip3 install \
#     PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl \
#     pynetbox-7.0.1-py3-none-any.whl \
#     bcrypt-4.0.1-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl \
#     paramiko-3.1.0-py3-none-any.whl \
#     pytz-2023.3-py2.py3-none-any.whl \
#     resolvelib-0.8.1-py2.py3-none-any.whl \
#     Jinja2-3.1.2-py3-none-any.whl \
#     MarkupSafe-2.1.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl \
#     packaging-23.1-py3-none-any.whl \
#     requests-2.30.0-py3-none-any.whl \
#     pyhcl-0.4.4-py3-none-any.whl \
#     hvac-1.1.0-py3-none-any.whl \
#     && \
# sha256sum --check --ignore-missing requirements_checksums.txt && \
# sha256sum --check --ignore-missing downloads_checksums.txt && \

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
USER    ${username}

WORKDIR ${WORKDIR}
# VOLUME [ "${WORKDIR}" ]
ENTRYPOINT [ "/entry.sh" ]
# CMD [ "/start.sh" ]
