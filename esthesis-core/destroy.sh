#!/usr/bin/env sh
helmfile destroy --skip-deps
kubectl delete pvc data-volume-esthesis-mongodb-esthesiscore-0
kubectl delete pvc logs-volume-esthesis-mongodb-esthesiscore-0
