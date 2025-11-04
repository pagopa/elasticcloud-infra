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
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4 | c75765102e77026cb603ea4c33984d2d688bd56b |
| <a name="module_app_resources"></a> [app\_resources](#module\_app\_resources) | ./.terraform/modules/__v4__/elastic_app_resources | n/a |

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_component_template.apm_components_logs_custom_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_component_template) | resource |
| [elasticstack_elasticsearch_component_template.apm_components_metrics_custom_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_component_template) | resource |
| [elasticstack_elasticsearch_index_lifecycle.index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_elasticsearch_index_template.logs_apm_index_template](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_template) | resource |
| [elasticstack_elasticsearch_index_template.metrics_apm_index_template](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_template) | resource |
| [elasticstack_kibana_action_connector.app_connector](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/kibana_action_connector) | resource |
| [elasticstack_kibana_space.kibana_space](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/kibana_space) | resource |
| [azurerm_key_vault.key_vault_org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.target_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.app_connector_secret_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elasticsearch_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [ec_deployment.deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |
| [ec_deployments.deployments](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployments) | data source |
| [elasticstack_fleet_integration.kubernetes](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |
| [elasticstack_fleet_integration.system](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_channels"></a> [alert\_channels](#input\_alert\_channels) | (Optional) Map of alert channels to be used for alerts. Default is all false | <pre>object({<br/>    email    = bool<br/>    slack    = bool<br/>    opsgenie = bool<br/>  })</pre> | <pre>{<br/>  "email": false,<br/>  "opsgenie": false,<br/>  "slack": false<br/>}</pre> | no |
| <a name="input_apm_logs_metrics_ilm"></a> [apm\_logs\_metrics\_ilm](#input\_apm\_logs\_metrics\_ilm) | (Required) Map containing the service name which require a custom ilm for this environment associated to the related index lifecycle management policy to be used for that service. The allowed values are the file names in `default_library/ilm` folder | `map(string)` | `{}` | no |
| <a name="input_app_connectors"></a> [app\_connectors](#input\_app\_connectors) | (optional) Map of <connector name>-<connector details> for additional connectors dedicated to app alerts. supports slack and opsgenie type | <pre>map(object({<br/>    type       = string<br/>    secret_key = string<br/>  }))</pre> | `{}` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_email_recipients"></a> [email\_recipients](#input\_email\_recipients) | (Optional) Map of List of email recipients associated to a name. to be used for email alerts. Default is empty | `map(list(string))` | `{}` | no |
| <a name="input_env"></a> [env](#input\_env) | (Required) Environment name | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ilm"></a> [ilm](#input\_ilm) | (Required) Map containing all the application name for this environment associated to the related index lifecycle management policy to be used for that application. The allowed values are the file names in `default_library/ilm` folder | `map(string)` | n/a | yes |
| <a name="input_ilm_delete_wait_for_snapshot"></a> [ilm\_delete\_wait\_for\_snapshot](#input\_ilm\_delete\_wait\_for\_snapshot) | Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not | `bool` | n/a | yes |
| <a name="input_lifecycle_policy_wait_for_snapshot"></a> [lifecycle\_policy\_wait\_for\_snapshot](#input\_lifecycle\_policy\_wait\_for\_snapshot) | (Optional) True if the index lifecycle policy has to wait for snapshots before deletion | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_primary_shard_count"></a> [primary\_shard\_count](#input\_primary\_shard\_count) | (Optional) Number of primary shards to be used for the index template. Default is 1. keep in mind to tune this value accordingly to the available number of nodes | `number` | `1` | no |
| <a name="input_total_shards_per_node"></a> [total\_shards\_per\_node](#input\_total\_shards\_per\_node) | (Optional) Maximum number of shards (primary + replica) to be stored on a node for each index. Default is 2. | `number` | `2` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
