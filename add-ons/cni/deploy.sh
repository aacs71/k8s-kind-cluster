#!/bin/bash

kubectl apply -k ./calico/

kubectl wait --namespace kube-system --for=condition=Ready pods --all --timeout=90s