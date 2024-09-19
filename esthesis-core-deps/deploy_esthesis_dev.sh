#!/bin/bash
export DOMAIN=esthesis-dev.eurodyn.com
export TIMEZONE=Europe/Athens
export ESTHESIS_ADMIN_USERNAME=esthesis-admin
export ESTHESIS_ADMIN_PASSWORD=esthesis-admin
export ESTHESIS_SYSTEM_USERNAME=esthesis-system
export ESTHESIS_SYSTEM_PASSWORD=esthesis-system
export KEYCLOAK_HOSTNAME=keycloak.$DOMAIN
export ESTHESIS_HOSTNAME=esthesis-core.$DOMAIN
export ESTHESIS_REPORTED_OIDC_AUTHORITY_URL="https://$KEYCLOAK_HOSTNAME/realms/esthesis"
export ESTHESIS_REPORTED_OIDC_POST_LOGOUT_URL="https://$ESTHESIS_HOSTNAME/logged-out"
export OIDC_AUTH_SERVER_URL="https://$KEYCLOAK_HOSTNAME/realms/esthesis"
export OIDC_CLIENT_AUTH_SERVER_URL="https://$KEYCLOAK_HOSTNAME/realms/esthesis"
export INGRESS_CLASS_NAME=nginx-esthesis-demo
export INGRESS_NGINX_ENABLED=true
export INGRESS_NGINX_LOAD_BALANCER_IP="10.250.98.191"
export INGRESS_NGINX_CUSTOM_SSL="wildcard-tls"
export ESTHESIS_LOCAL_CHARTS=true
export IMAGE_PULL_SECRET=regcred
export ESTHESIS_REGISTRY_URL=harbor.devops-d2.eurodyn.com/esthesis

# Run Helmfile command
helmfile sync -n esthesis-demo