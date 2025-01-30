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
      source  = "elastic/elasticstack"
      # version required to avoid a bug on integration policy: https://github.com/elastic/terraform-provider-elasticstack/issues/999
      # version documented here https://github.com/elastic/terraform-provider-elasticstack/issues/836
      version = "0.11.7"
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

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${var.aks_name}"
}
