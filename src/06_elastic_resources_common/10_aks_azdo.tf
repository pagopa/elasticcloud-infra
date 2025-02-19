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
