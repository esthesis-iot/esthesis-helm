#!/usr/bin/env bash
# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

helmfile destroy --skip-deps --namespace $1

kubectl -n $1 delete pvc data-camunda-zeebe-0
kubectl -n $1 delete pvc data-camunda-zeebe-1
kubectl -n $1 delete pvc data-camunda-zeebe-2
kubectl -n $1 delete pvc data-keycloak-postgresql-0
kubectl -n $1 delete pvc elasticsearch-master-elasticsearch-master-0
kubectl -n $1 delete pvc redis-data-redis-master-0
kubectl -n $1 delete pvc data-kafka-controller-0
kubectl -n $1 delete pvc data-kafka-controller-1
kubectl -n $1 delete pvc data-kafka-controller-2
kubectl -n $1 delete pvc datadir-mongodb-0
kubectl -n $1 delete pvc datadir-mongodb-1
kubectl -n $1 delete pvc elasticsearch-master-elasticsearch-master-1
kubectl -n $1 delete pvc data-grafana-loki-ingester-0
kubectl -n $1 delete pvc data-grafana-loki-querier-0
kubectl -n $1 delete pvc data-grafana-tempo-ingester-0
