#!/usr/bin/env bash
pushd .
cd esthesis-core
./package.sh
popd
pushd .
cd esthesis-core-deps
./package.sh
popd
