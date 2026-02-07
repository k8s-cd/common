#!/usr/bin/env bash
#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/refs/heads/main/argocd-core.sh | bash
set -euo pipefail
use_sudo=true 
if $use_sudo ; then
  sudo -i
fi
cluster_name="${1:-${KIND_CLUSTER:-kind-nginx}}"
kubeconfig="--kubeconfig $HOME/.kube/$cluster_name"

kubectl $kubeconfig -n argocd-core create -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/core-install.yaml
