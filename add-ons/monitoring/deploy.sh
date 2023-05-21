#!/bin/bash

kubectl apply --server-side -f ./reference/setup

kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring

cat <<EOT > grafana-certs-secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: grafana-certs
  namespace: monitoring
type: kubernetes.io/tls
data:
  tls.crt: $(base64 -w 0 ../../certs/grafana-crt.pem)
  tls.key: $(base64 -w 0 ../../certs/grafana-key.pem)
EOT

cat <<EOT > prometheus-certs-secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: prometheus-certs
  namespace: monitoring
type: kubernetes.io/tls
data:
  tls.crt: $(base64 -w 0 ../../certs/prometheus-crt.pem)
  tls.key: $(base64 -w 0 ../../certs/prometheus-key.pem)
EOT

cat <<EOT > alertmanager-certs-secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: alertmanager-certs
  namespace: monitoring
type: kubernetes.io/tls
data:
  tls.crt: $(base64 -w 0 ../../certs/alertmanager-crt.pem)
  tls.key: $(base64 -w 0 ../../certs/alertmanager-key.pem)
EOT

kubectl apply -k ./
