#!/usr/bin/env bash
CHART_VERSION=$(helm show chart . | awk '/version/ {print $2}')
echo "CHART_VERSION: $CHART_VERSION"

# Package and index Helm.
helm package . -d ../../esthesis-docs/helm
pushd .
cd ../../esthesis-docs/helm
helm repo index .
popd

# Rename Helmfile by suffixing the version and copy it to docs.
tar cvfz ../../esthesis-docs/helm/helmfile-esthesis-core-backups-$CHART_VERSION.tgz helmfile.yaml