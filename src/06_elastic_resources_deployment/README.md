# elastic cloud resources deployment

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

## RBAC AKS configuration - Azure Devops IaC

For the IaC pipelines to run properly, the cluster roles used by the `azure-devops` service account need the correct permissions.
You can check them in this PR:
[#2825](https://github.com/pagopa/pagopa-infra/pull/2825)

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12.2 |
| <a name="requirement_elasticstack"></a> [elasticstack](#requirement\_elasticstack) | 0.11.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.20.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_component_template.custom_components_default_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_component_template) | resource |
| [elasticstack_elasticsearch_index_lifecycle.deployment_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_elasticsearch_index_lifecycle.index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_elasticsearch_index_template.elastic_index_template](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_template) | resource |
| [elasticstack_elasticsearch_index_template.metricbeat_index_template](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_template) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elasticsearch_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [ec_deployment.deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |
| [ec_deployments.deployments](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_ilm_elastic"></a> [default\_ilm\_elastic](#input\_default\_ilm\_elastic) | ILM used by default index templates via elastic@custom | `string` | n/a | yes |
| <a name="input_default_ilm_logs"></a> [default\_ilm\_logs](#input\_default\_ilm\_logs) | ILM used by default index templates via logs@custom | `string` | n/a | yes |
| <a name="input_default_ilm_metrics"></a> [default\_ilm\_metrics](#input\_default\_ilm\_metrics) | ILM used by default index templates via metrics@custom | `string` | n/a | yes |
| <a name="input_default_ilm_traces"></a> [default\_ilm\_traces](#input\_default\_ilm\_traces) | ILM used by default index templates via traces@custom | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_elastic_apikey_env"></a> [elastic\_apikey\_env](#input\_elastic\_apikey\_env) | Env to be used when building the KV name to retrieve the elasticsearch api key | `string` | n/a | yes |
| <a name="input_elastic_apikey_env_short"></a> [elastic\_apikey\_env\_short](#input\_elastic\_apikey\_env\_short) | Short env to be used when building the KV name to retrieve the elasticsearch api key | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ilm_delete_wait_for_snapshot"></a> [ilm\_delete\_wait\_for\_snapshot](#input\_ilm\_delete\_wait\_for\_snapshot) | Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not | `bool` | n/a | yes |
| <a name="input_kv_name_org_ec"></a> [kv\_name\_org\_ec](#input\_kv\_name\_org\_ec) | n/a | `string` | n/a | yes |
| <a name="input_kv_rg_org_ec"></a> [kv\_rg\_org\_ec](#input\_kv\_rg\_org\_ec) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
