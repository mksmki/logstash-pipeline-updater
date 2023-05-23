### Vault commands

```bash
$ docker run --cap-add=IPC_LOCK -d --net netbox-docker_default --name=dev-vault hashicorp/vault:1.13
$ docker exec -ti dev-vault sh

--- Inside running container

~ # export VAULT_ADDR=http://127.0.0.1:8200

~ # vault kv put -mount=secret snmp @snmp.json
== Secret Path ==
secret/data/snmp

======= Metadata =======
Key                Value
---                -----
created_time       xxx
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

~ # vault kv put -mount=secret logstash @logstash.json
==== Secret Path ====
secret/data/logstash

======= Metadata =======
Key                Value
---                -----
created_time       xxx
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            2

~ # vault kv put -mount=secret netbox @netbox.json
=== Secret Path ===
secret/data/netbox

======= Metadata =======
Key                Value
---                -----
created_time       xxx
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

```
