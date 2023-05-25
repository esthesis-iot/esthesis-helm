#!/bin/bash

HOSTS_FILE="/etc/hosts"

# Find the entries exposed by the ingress controller.
INGRESS_IP=$(kubectl -n ingress get service ingress -o=jsonpath='{.status.loadBalancer.ingress[].ip}')
INGRESS_ENTRIES="$INGRESS_IP grafana.esthesis.localdev keycloak.esthesis.localdev apisix-dashboard.esthesis.localdev apisix-gateway.esthesis.localdev influxdb-ui.esthesis.localdev"

# Insert HOST_ENTRIES between HOSTS_START and HOSTS_END.
echo "Updating hosts file with new entries:"
sudo sed -i '' '/###ESTHESIS-START###/,/###ESTHESIS-END###/d' $HOSTS_FILE
echo "###ESTHESIS-START###" | sudo tee -a $HOSTS_FILE
echo "$INGRESS_ENTRIES" | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service grafana-loki-gelf -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" gelf-ingester.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service kafka-0-external -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" kafka.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service redis-master -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" redis.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service mosquitto -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" mqtt.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service grafana-tempo-distributor -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" otel-ingester.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service camunda-zeebe-gateway -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" camunda-zeebe-gateway.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service mongodb -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" mongodb.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "$(kubectl get service influxdb -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" influxdb.esthesis.localdev | sudo tee -a $HOSTS_FILE
echo "###ESTHESIS-END###" | sudo tee -a $HOSTS_FILE
