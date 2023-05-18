#!/usr/bin/env sh
CHART_VERSION=$(cat Chart.yaml | grep version | sed "s/version: //g")
echo "CHART_VERSION: $CHART_VERSION"

# Package and index Helm.
helm package . -d ../../esthesis-docs/helm
pushd .
cd ../../esthesis-docs/helm
helm repo index .
popd

# Rename Helmfile by suffixing the version and copy it to docs.
cp helmfile.yaml ../../esthesis-docs/helm/helmfile-esthesis-core-deps-$CHART_VERSION.yaml
