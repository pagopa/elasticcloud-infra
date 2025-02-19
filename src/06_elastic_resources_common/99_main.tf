terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1"
    }
    ec = {
      source  = "elastic/ec"
      version = "~> 0.12.2"
    }
    elasticstack = {
      source = "elastic/elasticstack"
      # version required to avoid a bug on integration policy: https://github.com/elastic/terraform-provider-elasticstack/issues/999
      # version documented here https://github.com/elastic/terraform-provider-elasticstack/issues/836
      version = "0.11.7"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.17.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "ec" {
  apikey = data.azurerm_key_vault_secret.elastic_cloud_api_key.value
}

provider "elasticstack" {
  elasticsearch {
    api_key   = data.azurerm_key_vault_secret.elasticsearch_api_key.value
    endpoints = [data.ec_deployment.deployment.elasticsearch[0].https_endpoint]
  }
  kibana {
    endpoints = [data.ec_deployment.deployment.kibana[0].https_endpoint]
  }
}


locals {
  cluster_1_config_path = "${var.k8s_kube_config_path_prefix}/config-${var.aks_config[0].name}"
  # if secondary cluster is not defined, use the primary cluster name just to make the provider configuration work. it will not be used
  cluster_2_config_path = "${var.k8s_kube_config_path_prefix}/config-${length(var.aks_config) > 1 ? var.aks_config[1].name : var.aks_config[0].name}"
}

provider "kubectl" {
  alias       = "cluster_1"
  config_path = local.cluster_1_config_path
}

provider "kubectl" {
  alias       = "cluster_2"
  config_path = local.cluster_2_config_path
}


provider "helm" {
  alias = "cluster_1"
  kubernetes {
    config_path = local.cluster_1_config_path
  }
}

provider "helm" {
  alias = "cluster_2"
  kubernetes {
    config_path = local.cluster_2_config_path
  }
}


module "__v4__" {
  # 1.8.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4?ref=659a44db66e6fbfaddd56471a9ee304ac7f074eb"
}