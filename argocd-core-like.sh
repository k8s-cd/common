#!/usr/bin/env bash
###############################################################
#  ARGOCD-CORE-LIKE because argocd core not work by default
#  https://github.com/argoproj/argo-cd/issues/12903
###############################################################

#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core-like.sh | bash
set -euo pipefail
use_sudo=true 
if $use_sudo ; then
  sudo -i
fi
cluster_name="${1:-${KIND_CLUSTER:-kind-nginx}}"
export KUBECONFIG="$HOME/.kube/$cluster_name"
k="kubectl"
ns=argocd-core

$k create ns $ns
helm repo add argo https://argoproj.github.io/argo-helm
helm  upgrade --install $ns  argo/argo-cd --namespace $ns --set notifications.enabled=false --set dex.enabled=false --set redis.enabled=true --set server.replicas=1 --set configs.cm.admin.enabled=false --set applicationSet.replicas=0 --create-namespace

k="$k -n $ns "
$k wait --for=condition=Available deployment/argocd-applicationset-controller deployment/argocd-redis deployment/argocd-repo-server --timeout=5m
