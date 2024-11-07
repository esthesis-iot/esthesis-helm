#!/usr/bin/env bash
pushd .
cd esthesis-core
./package.sh
popd

pushd .
cd esthesis-core-deps
./package.sh
popd

pushd .
cd esthesis-core-backups
./package.sh
popd

pushd .
cd esthesis-edge
./package.sh
popd
