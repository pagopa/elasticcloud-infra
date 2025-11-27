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
  # 7.53.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4?ref=54434830cc35c831c88f784ffa55bcfebbceefbb"
}