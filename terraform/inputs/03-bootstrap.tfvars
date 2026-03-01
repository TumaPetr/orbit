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
      },
      {
        name = "cert-manager-config"
        path = "./cluster/infra-config/cert-manager"
        depends_on = ["cert-manager"]
      },
      {
        name = "external-secrets-config"
        path = "./cluster/infra-config/external-secrets"
        depends_on = ["external-secrets"]
      },
      {
        name = "envoy-gateway-config"
        path = "./cluster/infra-config/envoy-gateway"
        depends_on = ["envoy-gateway"]
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
