# Infra

## Getting Started

### DNS

You will have to configure your resolved.conf to point to the network interface.  Look for the bridge interface with state UP.  You can find this using the `ip addr` command.

```
# /etc/systemd/resolved.conf
[Resolve]
DNS=172.19.0.100
Domains=kind
```

* Restart computer or `sudo systemctl restart systemd-resolved`

### Running

Run terraform in each terrafor/* subdir in order.

Ex:
```bash
cd terraform/010_k8s
terraform apply -auto-approve
```

## Services

* airflow.kind
* db.internal (postgres)


## Architecture

```mermaid
flowchart TD
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

    030_infra --> 020_base
    020_base --> 010_base
```
