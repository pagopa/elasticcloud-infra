# elastic cloud resources

## EC deployment id

This module requires to know the deployment id where to create the elastic resources; to do so you need to configure the `deployment_name` 
variable with the custom alias set in the `04_elastic_deployment` module, it will be used to retrieve the list of deployment with that name prefix, and the the correct deployment id

### The deployment is shared between DEV and UAT environment. this meta environment is caled STAGING

## Elasticsearch api key
in order to use the "elasticstack" provider you need to configure your kibana api key in your system [guide here](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs#environment-variables)

The recommended solution is to define environment variables as follows
```commandline
export ELASTICSEARCH_API_KEY=<deployment api key from kibana portal>
```
**NOTE**: this is different from the elastic cloud api key

for details on how to configure a new space/application, please refer to the `config` folder README


<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12.2 |
| <a name="requirement_elasticstack"></a> [elasticstack](#requirement\_elasticstack) | 0.11.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4 | d9aee53bcf1d1e01594cc3276447afe0635d1789 |
| <a name="module_app_resources"></a> [app\_resources](#module\_app\_resources) | ./.terraform/modules/__v4__/elastic_app_resources | n/a |

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_component_template.default_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_component_template) | resource |
| [elasticstack_elasticsearch_index_lifecycle.index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_kibana_space.kibana_space](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/kibana_space) | resource |
| [azurerm_key_vault.key_vault_org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.target_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elasticsearch_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [ec_deployment.deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |
| [ec_deployments.deployments](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployments) | data source |
| [elasticstack_fleet_integration.kubernetes](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |
| [elasticstack_fleet_integration.system](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_ilm"></a> [default\_ilm](#input\_default\_ilm) | ILM used by default index templates via logs@custom, traces@custom and metrics@custom | `string` | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) Environment name | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ilm"></a> [ilm](#input\_ilm) | (Required) Map containing all the application name for this environment associated to the related index lifecycle management policy to be used for that application. The allowed values are the file names in `default_library/ilm` folder | `map(string)` | n/a | yes |
| <a name="input_ilm_delete_wait_for_snapshot"></a> [ilm\_delete\_wait\_for\_snapshot](#input\_ilm\_delete\_wait\_for\_snapshot) | Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not | `bool` | n/a | yes |
| <a name="input_lifecycle_policy_wait_for_snapshot"></a> [lifecycle\_policy\_wait\_for\_snapshot](#input\_lifecycle\_policy\_wait\_for\_snapshot) | (Optional) True if the index lifecycle policy has to wait for snapshots before deletion | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_use_embedded_snapshot_policy"></a> [use\_embedded\_snapshot\_policy](#input\_use\_embedded\_snapshot\_policy) | If true, uses the embedded 'cloud-snapshot-policy' instead of 'default\_snapshot\_policy' | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
