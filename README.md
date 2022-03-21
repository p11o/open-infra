# OpenInfra

A infrastructure project for a typical tech company.  This project includes OSS projects for:

* Identity Management
* Project Management
* CI/CD
* VCS
* Prototyping

## Quickstart

* Run `bin/start`
* Follow instructions printed after the start command completes (update /etc/hosts)

## Prereqs

* kind
* terraform
* helm
* kubectl


## Configuring a repo w/ argo workflows

* [A Repo] > Settings > Webhooks
* Set Target URL to `http://gitea-to-argo.argo.svc.cluster.local/api/v1/events/argo/`
* Click "Add Webhook"
