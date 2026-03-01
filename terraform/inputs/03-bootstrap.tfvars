prefix              = "orbit"
github_organization = "TumaPetr"
github_repository   = "orbit"
gitops_branch       = "main"

gitops_configurations = {
  "cluster-infrastructure" = {
    namespace = "flux-system"
    kustomizations = [
      {
        name = "cert-manager"
        path = "./cluster/infra/cert-manager"
      },
      {
        name = "external-secrets"
        path = "./cluster/infra/external-secrets"
      },
      {
        name = "envoy-gateway"
        path = "./cluster/infra/envoy-gateway"
      }
    ]
  }

  "cluster-apps" = {
    namespace = "flux-system"
    kustomizations = [
      {
        name = "demo-app"
        path = "./cluster/apps/demo-app"
      }
    ]
  }
}
