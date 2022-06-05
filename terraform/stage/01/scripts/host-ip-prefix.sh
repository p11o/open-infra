#!/usr/bin/env bash

kubectl get nodes -o json \
    | jq -r '.items[0].status.addresses[0].address' \
    | cut -f1,2 -d'.' \
    | sed -E 's/(.*)/{"ip":"\1"}/'
