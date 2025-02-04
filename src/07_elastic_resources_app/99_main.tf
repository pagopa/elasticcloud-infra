terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
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

provider "elasticstack" {
  elasticsearch {
    endpoints = [data.ec_deployment.ec_deployment.elasticsearch[0].https_endpoint]
  }
  kibana {
    endpoints = [data.ec_deployment.ec_deployment.kibana[0].https_endpoint]
  }
}


provider "kubectl" {
  alias       = "cluster_1"
  config_path = "${var.k8s_kube_config_path_prefix}/config-${var.aks_names[0]}"
}

provider "kubectl" {
  alias = "cluster_2"
  # if secondary cluster is not defined, use the primary cluster name just to make the provider configuration work. it will not be used
  config_path = "${var.k8s_kube_config_path_prefix}/config-${length(var.aks_names) > 1 ? var.aks_names[1] : var.aks_names[0]}"
}
