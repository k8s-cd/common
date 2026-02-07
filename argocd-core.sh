#!/usr/bin/env bash
#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core.sh | bash
set -euo pipefail
cluster_name="${1:-${KIND_CLUSTER:-kind-nginx}}"
use_sudo=true #var_use_sudo
kubeconfig="--kubeconfig $HOME/.kube/$cluster_name"

if $use_sudo ; then
  sudo -i
fi
kubectl $kubeconfig -n argocd-core create -f https://raw.githubusercontent.com/argoproj/argo-cd/refs/heads/master/manifests/core-install.yaml
