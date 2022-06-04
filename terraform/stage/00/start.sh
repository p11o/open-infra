#!/usr/bin/env bash

set -e

K8S_VERSION=1.23.4

kind create cluster \
    --image=kindest/node:v${K8S_VERSION} \
    --config=kind/cluster.yml

kubectl wait --for=condition=Ready=True node kind-control-plane
