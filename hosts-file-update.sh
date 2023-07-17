#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "${machine}" == "Cygwin" ]
then
   windir=$(cygpath -w /cygdrive/c/Windows)
   HOSTS_FILE="$windir/System32/drivers/etc/hosts"
else
  HOSTS_FILE="/etc/hosts"
fi

echo Environment ${machine} with hosts path $HOSTS_FILE

# Find the entries exposed by the ingress controller.
INGRESS_IP=$(kubectl -n ingress get service ingress -o=jsonpath='{.status.loadBalancer.ingress[].ip}')
INGRESS_ENTRIES="$INGRESS_IP grafana.esthesis.localdev keycloak.esthesis.localdev apisix-dashboard.esthesis.localdev apisix-gateway.esthesis.localdev influxdb-ui.esthesis.localdev"

# Insert HOST_ENTRIES between HOSTS_START and HOSTS_END.
echo "Updating hosts file with new entries:"
if [ "${machine}" == "Cygwin" ]
then
   sed -i '/###ESTHESIS-START###/,/###ESTHESIS-END###/d' $HOSTS_FILE
else
  sed -i '' '/###ESTHESIS-START###/,/###ESTHESIS-END###/d' $HOSTS_FILE
fi

echo "###ESTHESIS-START###" |  tee -a $HOSTS_FILE
echo "$INGRESS_ENTRIES" |  tee -a $HOSTS_FILE
echo "$INGRESS_IP docker-registry" |  tee -a $HOSTS_FILE
echo "$(kubectl get service grafana-loki-gelf -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" gelf-ingester.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service kafka-0-external -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" kafka.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service redis-master -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" redis.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service mosquitto -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" mqtt.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service grafana-tempo-distributor -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" otel-ingester.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service camunda-zeebe-gateway -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" camunda-zeebe-gateway.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service mongodb -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" mongodb.esthesis.localdev |  tee -a $HOSTS_FILE
echo "$(kubectl get service influxdb -o=jsonpath='{.status.loadBalancer.ingress[].ip}' || echo 127.0.0.1)" influxdb.esthesis.localdev |  tee -a $HOSTS_FILE
echo "###ESTHESIS-END###" |  tee -a $HOSTS_FILE
