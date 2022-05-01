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

### Stage 1

* __k8s__ - create and config kubernetes cluster
  * metallb
  * nginx load balancers (udp & tcp)
* __dns__ - create a dns server, and configure local system to use it

### Stage 2

* __kong__ - HTTP ingress for all apps
* __keycloak__ - IdP.  Create keycloak and configure api clients (gitea, concourse, etc...) for sso.
* __gitea__ - git service
* __concourse__ - CI engine

## Prereqs

* kind
* terraform
* helm
* kubectl
