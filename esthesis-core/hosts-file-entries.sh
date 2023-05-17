#!/usr/bin/env sh

# Get the IP of Traefik Load Balancer.
echo "Finding Traefik LB IP address..."
LB=$(kubectl -n kube-system get service traefik -o=jsonpath='{.status.loadBalancer.ingress[].ip}')
if [ -z "$LB" ]
then
      echo "Could not find Traefik's IP address."
      exit 1
else
      echo "Found address $LB."
fi

# Create hosts file extract.
echo Add the following entry in your hosts file:
echo
echo $LB esthesis-core.esthesis.localdev
echo $LB keycloak.esthesis.localdev
echo $(kubectl get service esthesis-dev-mongodb-service -o=jsonpath='{.status.loadBalancer.ingress[].ip}') mongodb.esthesis.localdev
