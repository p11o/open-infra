#!/usr/bin/env bash


NAMESPACE=$1

kubectl -n $NAMESPACE get svc -o jsonpath='{.items[0].spec}' | jq '{clusterIP}'
