# Infra

## Getting dns working

```
# /etc/systemd/resolve.conf
[Resolve]
DNS=172.20.0.100
Domains=kind
```

* Restart computer or `sudo systemctl restart systemd-resolved`

## Services

* airflow.kind
* db.internal (postgres)


## Architecture

```mermaid
flowchart BT
    subgraph 010_base
        k8s
    end

    subgraph 020_base
        metallb
        coredns
        postgres
    end

    subgraph 030_infra
        airflow
        kong
    end
```