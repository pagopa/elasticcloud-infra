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
    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "<= 2.3.4"
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

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v4__" {
  #
  source = "git::https://github.com/pagopa/terraform-azurerm-v4?ref=PAYMCLOUD-209-cstar-terraform-v4-migration-from-v3" #fixme set a stable version when migration completed
}
