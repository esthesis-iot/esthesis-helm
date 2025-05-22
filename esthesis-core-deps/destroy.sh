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
  data-kafka-controller-0
  data-postgresql-0
  data-esthesis-core-deps-postgresql-0
  data-zeebe-0
  datadir-mongodb-0
  redis-data-redis-master-0
  redis-data-esthesis-core-deps-redis-master-0
  data-esthesis-core-deps-grafana-loki-ingester-0
  data-esthesis-core-deps-grafana-loki-querier-0
  data-esthesis-core-deps-grafana-tempo-ingester-0
  data-esthesis-core-deps-kafka-controller-0
  data-esthesis-core-deps-kafka-controller-1
  data-esthesis-core-deps-kafka-controller-2
  data-esthesis-core-deps-zeebe-0
  data-esthesis-core-deps-zeebe-1
  data-esthesis-core-deps-zeebe-2
  redis-data-esthesis-core-deps-redis-replicas-0
  redis-data-esthesis-core-deps-redis-replicas-1
)
for pvc in "${pvcs[@]}"; do
  kubectl -n "$1" delete pvc "$pvc" --ignore-not-found
done

# Delete secrets.
secrets=(
  esthesis-core-deps-ingress-nginx-admission
)
for secret in "${secrets[@]}"; do
  kubectl -n "$1" delete secret "$secret" --ignore-not-found
done