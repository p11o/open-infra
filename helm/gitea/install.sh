#/usr/bin/env bash
helm repo add gitea-charts https://dl.gitea.com/charts/
helm repo update
helm install -n gitea gitea gitea-charts/gitea --create-namespace -f ./helm/gitea/values.yaml
helm upgrade --install -n gitea gitea gitea-charts/gitea --create-namespace -f ./helm/gitea/values.yaml