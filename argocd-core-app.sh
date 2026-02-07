#!/usr/bin/env bash
#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core-app.sh | bash
set -euo pipefail
use_sudo=true 
if $use_sudo ; then
  sudo -i
fi

repoURL='https://github.com/k8s-cd/kind-framework-12.git'
namespace='argocd-core'
cluster_name='kind-nginx'

repoURL="${1:-${REPO_URL:-$repoURL}}"
namespace="${1:-${NAMESPACE:-$namespace}}"
cluster_name="${1:-${KIND_CLUSTER:-$kind-nginx}}"

k="kubectl --kubeconfig $HOME/.kube/$cluster_name -n $namespace "


$k  -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 0-core-apps
  namespace: "$namespace"
spec:
  ignoreDifferences:
    - group: argoproj.io
      kind: Application
      jsonPointers:
        - /operation
  project: default
  source:
    repoURL: "$repoURL" 
    targetRevision: HEAD
    path: 0-core-apps

  destination:
    server: 'https://kubernetes.default.svc'
    namespace: "$namespace"

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
