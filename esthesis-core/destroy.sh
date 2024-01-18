#!/usr/bin/env bash
# Check if the number of arguments is not equal to 1
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <namespace>"
    exit 1
fi

helmfile destroy --skip-deps --namespace $1
