terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
    ec = {
      source  = "elastic/ec"
      version = "~> 0.12.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "~> 0.11"
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

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
