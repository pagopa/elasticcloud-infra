resource "kubernetes_namespace" "azdo_1" {
  provider = kubernetes.cluster_1

  metadata {
    name = local.azdo_kubernetes_namespace
  }
}

resource "kubernetes_service_account" "azdo_1" {
  provider = kubernetes.cluster_1

  metadata {
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
  automount_service_account_token = false
}

resource "kubernetes_secret_v1" "default_secret_1" {
  provider = kubernetes.cluster_1

  metadata {
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
    name      = "default-${local.azdo_kubernetes_namespace}"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.azdo_1.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "azure_devops_secret_1" {
  provider = kubernetes.cluster_1

  metadata {
    name      = kubernetes_secret_v1.default_secret_1.metadata[0].name
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
  binary_data = {
    "ca.crt" = ""
    "token"  = ""
  }
}

resource "kubernetes_role_binding" "deployer_binding_azdo_1" {
  provider = kubernetes.cluster_1
  metadata {
    name      = "deployer-binding"
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
}

resource "kubernetes_role_binding" "deployer_binding_agent_1" {
  provider = kubernetes.cluster_1
  metadata {
    name      = "deployer-binding"
    namespace = var.aks_config[0].elastic_agent.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
}

resource "kubernetes_role_binding" "deployer_binding_otel_1" {
  provider = kubernetes.cluster_1
  metadata {
    name      = "deployer-binding"
    namespace = var.aks_config[0].otel.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_1.metadata[0].name
  }
}

#
# Second Cluster
#

resource "kubernetes_namespace" "azdo_2" {
  count = length(var.aks_config) > 1 ? 1 : 0

  provider = kubernetes.cluster_2

  metadata {
    name = local.azdo_kubernetes_namespace
  }
}

resource "kubernetes_service_account" "azdo_2" {
  count = length(var.aks_config) > 1 ? 1 : 0

  provider = kubernetes.cluster_2

  metadata {
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
  automount_service_account_token = false
}

resource "kubernetes_secret_v1" "default_secret_2" {
  count = length(var.aks_config) > 1 ? 1 : 0

  provider = kubernetes.cluster_2

  metadata {
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
    name      = "default-${local.azdo_kubernetes_namespace}"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.azdo_2[0].metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "azure_devops_secret_2" {
  count = length(var.aks_config) > 1 ? 1 : 0

  provider = kubernetes.cluster_2

  metadata {
    name      = kubernetes_secret_v1.default_secret_2[0].metadata[0].name
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
  binary_data = {
    "ca.crt" = ""
    "token"  = ""
  }
}


resource "kubernetes_role_binding" "deployer_binding_azdo_2" {
  count = length(var.aks_config) > 1 ? 1 : 0
  provider = kubernetes.cluster_2
  metadata {
    name      = "deployer-binding"
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
}

resource "kubernetes_role_binding" "deployer_binding_agent_2" {
  count = length(var.aks_config) > 1 ? 1 : 0
  provider = kubernetes.cluster_2
  metadata {
    name      = "deployer-binding"
    namespace = var.aks_config[1].elastic_agent.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
}

resource "kubernetes_role_binding" "deployer_binding_otel_2" {
  count = length(var.aks_config) > 1 ? 1 : 0
  provider = kubernetes.cluster_2
  metadata {
    name      = "deployer-binding"
    namespace = var.aks_config[1].otel.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-deployer"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "azure-devops"
    namespace = kubernetes_namespace.azdo_2[0].metadata[0].name
  }
}

locals {
  azdo_devops_sa_token = length(var.aks_config) > 1 ? [
    data.kubernetes_secret.azure_devops_secret_1.binary_data["token"],
    try(data.kubernetes_secret.azure_devops_secret_2[0].binary_data["token"], null)
    ] : [
    data.kubernetes_secret.azure_devops_secret_1.binary_data["token"]
  ]

  azdo_devops_ca_crt = length(var.aks_config) > 1 ? [
    data.kubernetes_secret.azure_devops_secret_1.binary_data["ca.crt"],
    try(data.kubernetes_secret.azure_devops_secret_2[0].binary_data["ca.crt"], null)
    ] : [
    data.kubernetes_secret.azure_devops_secret_1.binary_data["ca.crt"]
  ]
}


#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_token" {
  count = length(var.aks_config)

  name         = "${var.aks_config[count.index].name}-azure-devops-sa-token"
  value        = local.azdo_devops_sa_token[count.index]
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.key_vault.id

  depends_on = [
    kubernetes_service_account.azdo_1,
    kubernetes_service_account.azdo_2
  ]
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "azure_devops_sa_cacrt" {
  count = length(var.aks_config)

  name         = "${var.aks_config[count.index].name}-azure-devops-sa-cacrt"
  value        = local.azdo_devops_ca_crt[count.index]
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.key_vault.id

  depends_on = [
    kubernetes_service_account.azdo_1,
    kubernetes_service_account.azdo_2
  ]
}

