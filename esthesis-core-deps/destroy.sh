#!/usr/bin/env sh
helmfile destroy --skip-deps
kubectl delete pvc data-apisix-etcd-0
kubectl delete pvc data-camunda-zeebe-0
kubectl delete pvc data-0-esthesis-core-kafka-kafka-0
kubectl delete pvc data-esthesis-core-kafka-zookeeper-0
kubectl delete pvc data-keycloak-postgresql-0
kubectl delete pvc elasticsearch-master-elasticsearch-master-0
kubectl delete pvc redis-data-redis-master-0
kubectl delete crd apisixclusterconfigs.apisix.apache.org apisixconsumers.apisix.apache.org apisixpluginconfigs.apisix.apache.org apisixroutes.apisix.apache.org apisixtlses.apisix.apache.org apisixupstreams.apisix.apache.org
kubectl delete pvc data-grafana-loki-ingester-0
kubectl delete pvc data-grafana-loki-querier-0
kubectl delete pvc data-grafana-tempo-ingester-0

