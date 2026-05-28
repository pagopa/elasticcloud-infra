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
      version = "0.16.0"
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



module "__v4__" {
  # 10.14.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4?ref=d3c39ec57248b786a749e5e24c1dcbaa6473ed8b"
}