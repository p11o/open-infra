# OpenInfra

A infrastructure project for a typical tech company.  This project includes OSS projects for:

* Identity Management (dex)
* Project Management (taiga)
* CI/CD (concourse)
* VCS (gitea)
* Prototyping (Penpot)
* Docker registry (registry)
* NPM registry (verdaccio)
* Python Index (devpi)
* Secrets (vault)

## Quickstart

* Run `bin/start [init]`

The optional init param is required for the first run.  It triggers the terraform init command.

* If you make changes to tf, and have already started the cluster, you can run `bin/tf-apply`

## Prereqs

* kind
* terraform
* helm
* kubectl
