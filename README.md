# Kong Application Setup

## Quickstart

bin/start

To get teh IP addresses of the services

```
# argocd
kubectl -n argo get svc
# Credentials:
# Username: admin
# Password:
kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# kong
kubectl -n kong get svc
```

## Prereqs

* kind
* terraform
* helm
* kubectl