#!/usr/bin/env bash
#curl -sSL https://raw.githubusercontent.com/k8s-cd/common/main/argocd-core-app.sh | bash
set -euo pipefail
s=""

repoURL='https://github.com/k8s-cd/kind-framework-12.git'
namespace='argocd-infra'
cluster_name='kind-nginx'
path='kind/infra'

path="${1:-${REPO_PATH:-$path}}"
repoURL="${2:-${REPO_URL:-$repoURL}}"
cluster_name="${3:-${KIND_CLUSTER:-$cluster_name}}"
namespace="${4:-${NAMESPACE:-$namespace}}"

k="$s kubectl --kubeconfig $HOME/.kube/$cluster_name -n $namespace "

$k apply -f - <<EOF
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
    path: "$path"

  destination:
    server: 'https://kubernetes.default.svc'
    namespace: "$namespace"

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
