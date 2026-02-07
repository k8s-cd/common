#!/usr/bin/env bash
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
$k -n $ns create -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/core-install.yaml
$k -n $ns wait --for=condition=Available deployment/argocd-applicationset-controller deployment/argocd-redis deployment/argocd-repo-server --timeout=5m
