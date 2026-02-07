#!/usr/bin/env bash

#########################################################
#  ARGOCD-CORE NOT WORK
#  https://github.com/argoproj/argo-cd/issues/12903
#########################################################


#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core.sh | bash
set -euo pipefail
use_sudo=true 
if $use_sudo ; then
  sudo -i
fi

cluster_name="${1:-${KIND_CLUSTER:-kind-nginx}}"
k="kubectl --kubeconfig $HOME/.kube/$cluster_name"
ns=argocd-core

$k create ns $ns
k="$k -n $ns "
$k create -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/core-install.yaml
$k wait --for=condition=Available deployment/argocd-applicationset-controller deployment/argocd-redis deployment/argocd-repo-server --timeout=5m
$k  apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: default
  namespace: $namespace
spec:
  sourceRepos:
    - '*'
  destinations:
    - namespace: '*'
      server: '*'
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
EOF
