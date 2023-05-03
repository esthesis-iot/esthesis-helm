#!/usr/bin/env sh
helm package . -d ../../esthesis-docs/helm && \
pushd . && \
cd ../../esthesis-docs/helm && \
helm repo index . && \
popd
