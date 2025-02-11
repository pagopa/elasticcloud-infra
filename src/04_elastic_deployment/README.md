# Elastic cloud deployment

This module creates the elastic deployment for the target environment and some related resources.

Here we use the "staging" environment to address the mixed "dev + uat" env and, in case of shared environment between multiple products, 
they must converge in the same environment folder. As an example, the "arp4pa-<env>" is actually the arc target together with p4pa target. 
They share the same deployment because they are both part of the same echosystem

In order to use the "ec" provider you need to configure your api key in your system [guide here](https://registry.terraform.io/providers/elastic/ec/latest/docs#api-key-authentication-recommended)

The recommended solution is to define environment variables as follows
```commandline
export EC_API_KEY=<elastic cloud organization api key>
```

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.16.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.ec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.ec_snapshot_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.snapshot_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [ec_deployment.elastic_cloud](https://registry.terraform.io/providers/elastic/ec/latest/docs/resources/deployment) | resource |
| [azuread_application.ec_application](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cold_config"></a> [cold\_config](#input\_cold\_config) | Cold storage node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |
| <a name="input_coordinating_config"></a> [coordinating\_config](#input\_coordinating\_config) | ES Coordinating node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | n/a | `string` | n/a | yes |
| <a name="input_elk_snapshot_sa"></a> [elk\_snapshot\_sa](#input\_elk\_snapshot\_sa) | n/a | <pre>object({<br/>    blob_delete_retention_days = number<br/>    backup_enabled             = bool<br/>    blob_versioning_enabled    = bool<br/>    advanced_threat_protection = bool<br/>    replication_type           = optional(string, "LRS")<br/>  })</pre> | <pre>{<br/>  "advanced_threat_protection": true,<br/>  "backup_enabled": true,<br/>  "blob_delete_retention_days": 30,<br/>  "blob_versioning_enabled": true,<br/>  "replication_type": "GZRS"<br/>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_hot_config"></a> [hot\_config](#input\_hot\_config) | Hot storage node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |
| <a name="input_integration_server"></a> [integration\_server](#input\_integration\_server) | n/a | <pre>object({<br/>    size          = string<br/>    zones         = number<br/>    size_resource = optional(string, "memory")<br/>  })</pre> | n/a | yes |
| <a name="input_kibana_config"></a> [kibana\_config](#input\_kibana\_config) | Kibana node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |
| <a name="input_kv_name_org_ec"></a> [kv\_name\_org\_ec](#input\_kv\_name\_org\_ec) | n/a | `string` | n/a | yes |
| <a name="input_kv_rg_org_ec"></a> [kv\_rg\_org\_ec](#input\_kv\_rg\_org\_ec) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_master_config"></a> [master\_config](#input\_master\_config) | ES Master node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_shared_env"></a> [shared\_env](#input\_shared\_env) | List of environments contained in this deployment | `list(string)` | n/a | yes |
| <a name="input_warm_config"></a> [warm\_config](#input\_warm\_config) | Warm storage node configuration | <pre>object({<br/>    size       = string<br/>    zone_count = number<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
