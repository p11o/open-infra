# Kong Application Setup

## Quickstart

Add the following to `/etc/hosts` (ip depends on 172.X subnet.  See IP on `kubectl get nodes -o wide`)

```
172.18.255.200	infra.local
```

Then run
`bin/start`



## Prereqs

* kind
* terraform
* helm
* kubectl
