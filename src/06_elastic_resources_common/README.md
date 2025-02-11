# elastic cloud resources common

## EC deployment id

This module requires to know the deployment id where to create the elastic resources; to do so you need to configure the `deployment_name` 
variable with the custom alias set in the `04_elastic_deployment` module, it will be used to retrieve the list of deployment with that name prefix, and the the correct deployment id


## Elasticsearch api key
To use the elasticstack provider, you must have access to the Key Vault dedicated the target monitored (e.g., pagopa-dev, arc-prod, p4pa-uat).
The API key used for provider authentication will be retrieved from this KV. [Guide here](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs#elasticsearch).

**NOTE**: this is different from the elastic cloud api key

## Snapshot repository setup
Before executing this module you need to define some properties in the elasticsearch keystore via elastic cloud portal:

| Name | Value |
|------|---------|
| `azure.client.<clientName>.account` | `<storage account name>` |
| `azure.client.<clientName>.key` | `<storage account access key>` |

these values are required to properly configure a snapshot repository client.
`clientName` is an arbitrary name assigned to the client, it must be different between the environments

**NB:** By convention, the requested name must be `<prefix><env_short>`, such as `pagopad`


- [how to configure anzure blob storage snapshot repo](https://www.elastic.co/guide/en/cloud/current/ec-azure-snapshotting.html)
- [more details on azure repository](https://www.elastic.co/guide/en/elasticsearch/reference/8.17/repository-azure.html)

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12.2 |
| <a name="requirement_elasticstack"></a> [elasticstack](#requirement\_elasticstack) | ~> 0.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.16.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_security_role.admin_role](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role.editor_role](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role.viewer_role](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role_mapping.admins_as_superuser](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_security_role_mapping.custom_role_mappings](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_security_role_mapping.kibana_admin](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_snapshot_lifecycle.default_snapshot_policy](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_snapshot_lifecycle) | resource |
| [elasticstack_elasticsearch_snapshot_repository.snapshot_repository](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_snapshot_repository) | resource |
| [elasticstack_fleet_integration.kubernetes_package](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/fleet_integration) | resource |
| [elasticstack_fleet_integration.system_package](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/fleet_integration) | resource |
| [azuread_group.adgroup](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elasticsearch_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [ec_deployment.deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |
| [ec_deployments.deployments](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_ilm"></a> [default\_ilm](#input\_default\_ilm) | Defines the default Index Lifecycle Management (ILM) policy stages for an Elasticsearch deployment. | `any` | `{}` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_role_mappings"></a> [role\_mappings](#input\_role\_mappings) | n/a | `map(any)` | `{}` | no |
| <a name="input_snapshot_lifecycle_default"></a> [snapshot\_lifecycle\_default](#input\_snapshot\_lifecycle\_default) | (Required) Identifier for the default snapshot lifecycle policy of the EC deployment. | <pre>object({<br/>    expire_after = string<br/>  })</pre> | <pre>{<br/>  "expire_after": "30d"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
