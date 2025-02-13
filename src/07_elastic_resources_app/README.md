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
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.17.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.18.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_resources"></a> [app\_resources](#module\_app\_resources) | ../../tf_module/app_resources | n/a |
| <a name="module_install_agent_cluster_1"></a> [install\_agent\_cluster\_1](#module\_install\_agent\_cluster\_1) | ../../tf_module/agent | n/a |
| <a name="module_install_agent_cluster_2"></a> [install\_agent\_cluster\_2](#module\_install\_agent\_cluster\_2) | ../../tf_module/agent | n/a |
| <a name="module_otel_cluster_1"></a> [otel\_cluster\_1](#module\_otel\_cluster\_1) | ../../tf_module/otel | n/a |
| <a name="module_otel_cluster_2"></a> [otel\_cluster\_2](#module\_otel\_cluster\_2) | ../../tf_module/otel | n/a |

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_component_template.default_index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_component_template) | resource |
| [elasticstack_elasticsearch_index_lifecycle.index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_fleet_agent_policy.kubernetes_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_agent_policy) | resource |
| [elasticstack_fleet_integration_policy.apm_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.kubernetes_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.system_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
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
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | (Required) list of aks cluster configurations where the elstic agent and otel will be installed. must not be empty, must not be more than 2 elements | <pre>list(object({<br/>    name = string<br/>    elastic_agent = object({<br/>      namespace = string<br/>      create_ns = bool<br/>    })<br/>    otel = object({<br/>      namespace = string<br/>      create_ns = bool<br/>      affinity_selector = optional(object({<br/>        key   = string<br/>        value = string<br/>      }), null)<br/>      receiver_port = optional(string, "4317")<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) Environment name | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ilm"></a> [ilm](#input\_ilm) | (Required) Map containing all the application name for this environment associated to the related index lifecicle management policy to be used for that application. The allowed values are the file names in `default_library/ilm` folder | `map(string)` | n/a | yes |
| <a name="input_ilm_delete_wait_for_snapshot"></a> [ilm\_delete\_wait\_for\_snapshot](#input\_ilm\_delete\_wait\_for\_snapshot) | Wheather or not the delete phase of every lifecycle policy for this environment needs to wait for snapshot policy to run or not | `bool` | n/a | yes |
| <a name="input_k8s_application_log_instance_names"></a> [k8s\_application\_log\_instance\_names](#input\_k8s\_application\_log\_instance\_names) | (Required) List of app namespaces or pod names for which the elastic agent will send logs | `list(string)` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | (Optional) path to the kube config folder | `string` | `"~/.kube"` | no |
| <a name="input_lifecycle_policy_wait_for_snapshot"></a> [lifecycle\_policy\_wait\_for\_snapshot](#input\_lifecycle\_policy\_wait\_for\_snapshot) | (Optional) True if the index lifecycle policy has to wait for snapshots before deletion | `bool` | `true` | no |
| <a name="input_opentelemetry_operator_helm_version"></a> [opentelemetry\_operator\_helm\_version](#input\_opentelemetry\_operator\_helm\_version) | Open telemetry operator version | `string` | `"0.24.3"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
