# Elastic cloud organization

This module provides the organization for elastic cloud deployments. It creates one organization and stores in the production state
all 3 environments (deployments) will belong to this organization

## How to

The organization cannot be created via terraform without an api key, and the api key canot be created without an organization. 
You must create the organization via EC portal and then import it, as documented [here](https://registry.terraform.io/providers/elastic/ec/latest/docs/resources/organization)

## Elastic cloud api key
in order to use the "ec" provider you need to configure your api key in your system [guide here](https://registry.terraform.io/providers/elastic/ec/latest/docs#api-key-authentication-recommended)

The recommended solution is to define environment variables as follows
```commandline
export EC_API_KEY=<elastic cloud organization api key>
```

**NOTE**: this is different from the elasticsearch api key



<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.16.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ec_organization.admin_elastic_cloud_organization](https://registry.terraform.io/providers/elastic/ec/latest/docs/resources/organization) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
