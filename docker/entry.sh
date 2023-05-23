#!/usr/bin/env bash

EXIT_SIGNAL=0

cleanup() {
    EXIT_SIGNAL=1
    echo "Cleaning up and going home..."
    exit 0
}

# Setting up a signal catcher for graceful shutdown
trap cleanup SIGINT SIGTERM

"$@"

[ -z $NETBOX_API -o -z NETBOX_TOKEN ] && {
    echo "Error: NETBOX_API or NETBOX_TOKEN is empty"
}

echo "[$(date --iso-8601=seconds)] Starting..."

while [[ $EXIT_SIGNAL -eq 0 ]]; do
    echo "$(date --iso-8601=seconds) Running..."

    # /usr/bin/env ansible-playbook -i netbox_inventory.yaml \
    /usr/bin/env ansible-playbook -i localhost, \
        -e "VAULT_URL=\"${VAULT_URL}\"" \
        -e "VAULT_TOKEN=\"${VAULT_TOKEN}\"" \
        -e "ELASTIC_URL=\"${ELASTIC_URL}\"" \
        -e "PIPELINE_ID=\"${PIPELINE_ID}\"" \
        main.yaml

    sleep ${RUN_INTERVAL:-30}
done

exit 0

        # -e "ansible_connection=local" \
        # -e "NETBOX_API=\"${NETBOX_API}\"" \
        # -e "NETBOX_TOKEN=\"${NETBOX_TOKEN}\"" \
