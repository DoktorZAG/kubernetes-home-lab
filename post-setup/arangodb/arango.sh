#!/bin/bash

ARANGO_VER=1.2.48
URLPREFIX=https://github.com/arangodb/kube-arangodb/releases/download/${ARANGO_VER}
helm upgrade --install kube-arangodb ${URLPREFIX}/kube-arangodb-${ARANGO_VER}.tgz --namespace arangodb --reuse-values --set operator.features.storage=true --set storage.enabled=true
