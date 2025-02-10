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
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
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

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}
