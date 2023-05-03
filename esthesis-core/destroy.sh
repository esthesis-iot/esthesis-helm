#!/usr/bin/env sh
helmfile destroy --skip-deps
kubectl delete pvc data-apisix-etcd-0
kubectl delete pvc data-keycloak-postgresql-0
kubectl delete pvc data-camunda-zeebe-0
kubectl delete pvc data-camunda-zeebe-1
kubectl delete pvc data-camunda-zeebe-2
kubectl delete pvc data-kafka-0
kubectl delete pvc data-kafka-zookeeper-0
kubectl delete pvc data-rabbitmq-0
kubectl delete pvc elasticsearch-master-elasticsearch-master-0
kubectl delete pvc elasticsearch-master-elasticsearch-master-1
kubectl delete pvc redis-data-redis-master-0



