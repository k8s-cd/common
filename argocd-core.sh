#!/usr/bin/env bash
#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core.sh | bash
set -euo pipefail
use_sudo=true 
if $use_sudo ; then
  sudo -i
fi
cluster_name="${1:-${KIND_CLUSTER:-kind-nginx}}"
namespace=argocd-core
kubeconfig="--kubeconfig $HOME/.kube/$cluster_name"

kubectl $kubeconfig create ns $namespace
kubectl $kubeconfig -n $namespace create -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/core-install.yaml
kubectl $kubeconfig -n $namespace wait --for=condition=Available deployment/argocd-applicationset-controller deployment/argocd-redis deployment/argocd-repo-server --timeout=120s
