#!/bin/bash

CLUSTER_NAME=${1:-"kind"}

kind create cluster --name $CLUSTER_NAME --config ./cluster-config.yaml --wait 2m

kubectl config use-context "kind-$CLUSTER_NAME" 