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

## Running

The infrastructure is broken up into stages.

`bin/start`

### Stage 0

* __k8s__ - create and config kubernetes cluster

### Stage 1

* __metallb__
* __ingress nginx__ - load balancers (udp & tcp)
* __dns__ - create a dns server, and configure local system to use it
* __kong__ - HTTP ingress for all apps

### Stage 2

* __keycloak__ - IdP.  Create keycloak and configure api clients (gitea, concourse, etc...) for sso.

### Stage 3

* __gitea__ - git service (repos are created in the next stage)
* __concourse__ - CI engine (pipelines are created in the next stage)

### Stage 4

* __concurse pipelines__ - Create concourse pipelines

## Prereqs

* kind
* terraform
* helm
* kubectl
