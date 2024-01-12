#!/usr/bin/env sh
helmfile destroy --skip-deps

kubectl delete pvc data-camunda-zeebe-0
kubectl delete pvc data-camunda-zeebe-1
kubectl delete pvc data-camunda-zeebe-2
kubectl delete pvc data-keycloak-postgresql-0
kubectl delete pvc elasticsearch-master-elasticsearch-master-0
kubectl delete pvc redis-data-redis-master-0
kubectl delete pvc data-kafka-controller-0
kubectl delete pvc data-kafka-controller-1
kubectl delete pvc data-kafka-controller-2
kubectl delete pvc datadir-mongodb-0
kubectl delete pvc datadir-mongodb-1
kubectl delete pvc elasticsearch-master-elasticsearch-master-1

