# OpenInfra

A infrastructure project for a typical tech company.  This project includes OSS projects for:

* Identity Management (keycloak)
* Project Management (taiga)
* CI/CD (concourse)
* VCS (gitea)
* Prototyping (Penpot)
* Docker registry (gitea)
* NPM registry (gitea)
* Python Index (gitea)
* Secrets (vault)

## Quickstart

* Run `bin/start [init]`

The optional init param is required for the first run.  It triggers the terraform init command.

## Prereqs

* kind
* terraform
* helm
* kubectl
