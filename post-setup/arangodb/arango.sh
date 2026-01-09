#!/bin/bash

kubectl create namespace arangodb

ARANGODB_VERSION=1.2.48
URLPREFIX=https://github.com/arangodb/kube-arangodb/releases/download/${ARANGODB_VERSION}
helm upgrade --install kube-arangodb ${URLPREFIX}/kube-arangodb-${ARANGODB_VERSION}.tgz --namespace arangodb --reuse-values --set operator.features.storage=true --set storage.enabled=true

# After that you can install arango-local-storage.yaml and arangodb-single.yaml and access the ArangoDB Instance from the Host Machine over the master IP using the service of type NodePort
