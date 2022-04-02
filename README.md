# OpenInfra

A infrastructure project for a typical tech company.  This project includes OSS projects for:

* Identity Management (glauth)
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

The optional init param is required for the first run.

## Prereqs

* kind
* terraform
* helm
* kubectl