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
  }

  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
