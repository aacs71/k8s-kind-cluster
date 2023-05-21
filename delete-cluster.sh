#!/bin/bash

CLUSTER_NAME=${1:-"kind"}

kind delete cluster --name $CLUSTER_NAME
