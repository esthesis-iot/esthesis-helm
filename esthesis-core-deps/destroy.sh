#!/usr/bin/env bash

# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

# Delete release.
helm -n "$1" uninstall esthesis-core-deps

# PVCs to delete.
pvcs=(
  postgres-1
  data-zeebe-0
  data-zeebe-1
  data-zeebe-2
  mongod-data-mongodb-rs0-0
  mongod-data-mongodb-rs0-1
  data-esthesis-core-deps-grafana-loki-ingester-0
  data-esthesis-core-deps-grafana-loki-querier-0
  data-esthesis-core-deps-grafana-tempo-ingester-0
  data-kafka-brokers-0
  data-kafka-brokers-1
  data-kafka-brokers-2
  data-kafka-controllers-3
  data-kafka-controllers-4
  data-kafka-controllers-5
  data-redis-0
  data-esthesis-core-deps-elasticsearch-master-0
  data-esthesis-core-deps-elasticsearch-master-1
  influxdb
)
for pvc in "${pvcs[@]}"; do
  kubectl -n "$1" delete pvc "$pvc" --ignore-not-found
done

# Delete secrets.
secrets=(
  esthesis-core-deps-nginx-ingress-admission
  mosquitto-acl
)
for secret in "${secrets[@]}"; do
  kubectl -n "$1" delete secret "$secret" --ignore-not-found
done

keycloak_secret=$(kubectl get secrets --no-headers -o custom-columns=":metadata.name" | grep '^keycloak')
if [ -n "$keycloak_secret" ]; then
  kubectl -n "$1" delete secret "$keycloak_secret" --ignore-not-found
fi