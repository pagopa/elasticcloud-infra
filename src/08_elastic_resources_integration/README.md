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

## How to configure `k8s_application_log_instance_names`

This variable is a map of `elastic_data_stream_name` and `namespace_or_pod_name` to be used by the elastic agent to collect logs from the application.
The data stream name must match the name used in the application `appSettings.json` file, while the namespace or pod name must be the one used in the application deployment.
All the logs collected from the `namespace_or_pod_name` will be directed to the same `elastic_data_stream_name`

Please, refer to [products readme](../07_elastic_resources_app/products/README.md) for more details

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
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.24.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.7 |
| <a name="provider_kubernetes.cluster_1"></a> [kubernetes.cluster\_1](#provider\_kubernetes.cluster\_1) | 2.36.0 |
| <a name="provider_kubernetes.cluster_2"></a> [kubernetes.cluster\_2](#provider\_kubernetes.cluster\_2) | 2.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4 | 873db3685d2b91fd4f2096f005fd6e6063b4aab3 |
| <a name="module_install_agent_cluster_1"></a> [install\_agent\_cluster\_1](#module\_install\_agent\_cluster\_1) | ./.terraform/modules/__v4__/elastic_cloud_agent | n/a |
| <a name="module_install_agent_cluster_2"></a> [install\_agent\_cluster\_2](#module\_install\_agent\_cluster\_2) | ./.terraform/modules/__v4__/elastic_cloud_agent | n/a |
| <a name="module_otel_cluster_1"></a> [otel\_cluster\_1](#module\_otel\_cluster\_1) | ./.terraform/modules/__v4__/open_telemetry | n/a |
| <a name="module_otel_cluster_2"></a> [otel\_cluster\_2](#module\_otel\_cluster\_2) | ./.terraform/modules/__v4__/open_telemetry | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [elasticstack_fleet_agent_policy.kubernetes_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_agent_policy) | resource |
| [elasticstack_fleet_integration.kubernetes_package](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration) | resource |
| [elasticstack_fleet_integration.system_package](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration) | resource |
| [elasticstack_fleet_integration_policy.apm_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.kubernetes_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.system_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [kubernetes_cluster_role_binding.system_deployer_binding_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.system_deployer_binding_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.azdo_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.azdo_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding_agent_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.deployer_binding_agent_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.deployer_binding_azdo_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.deployer_binding_azdo_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.deployer_binding_otel_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.deployer_binding_otel_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret_v1.default_secret_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.default_secret_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account.azdo_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.azdo_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.target_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.elastic_cloud_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.elasticsearch_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [ec_deployment.deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |
| [ec_deployments.deployments](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployments) | data source |
| [elasticstack_fleet_integration.kubernetes](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |
| [elasticstack_fleet_integration.system](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/data-sources/fleet_integration) | data source |
| [kubernetes_secret.azure_devops_secret_1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |
| [kubernetes_secret.azure_devops_secret_2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | (Required) list of aks cluster configurations where the elstic agent and otel will be installed. must not be empty, must not be more than 2 elements | <pre>list(object({<br/>    name = string<br/>    elastic_agent = object({<br/>      namespace = string<br/>      create_ns = bool<br/>      tolerated_taints = optional(list(object({<br/>        key    = string<br/>        effect = optional(string, "NoSchedule")<br/>      })), [])<br/>    })<br/>    otel = object({<br/>      namespace = string<br/>      create_ns = bool<br/>      affinity_selector = optional(object({<br/>        key   = string<br/>        value = string<br/>      }), null)<br/>      receiver_port = optional(string, "4317")<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) Environment name | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_k8s_application_log_instance_names"></a> [k8s\_application\_log\_instance\_names](#input\_k8s\_application\_log\_instance\_names) | (Required) Map of <elastic\_datastream\_name> - <namespace\_or\_pod\_name> for which the logs will be collected by the elastic agent | `map(list(string))` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | (Optional) path to the kube config folder | `string` | `"~/.kube"` | no |
| <a name="input_opentelemetry_operator_helm_version"></a> [opentelemetry\_operator\_helm\_version](#input\_opentelemetry\_operator\_helm\_version) | Open telemetry operator version | `string` | `"0.24.3"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_sampling_configuration"></a> [sampling\_configuration](#input\_sampling\_configuration) | Sampling configuration for the OpenTelemetry collector traces | <pre>object({<br/>    enabled                    = bool<br/>    probes_sampling_percentage = optional(number, 1)<br/>    sampling_percentage        = optional(number, 50)<br/>    probe_paths                = optional(list(string), [])<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "probe_paths": [],<br/>  "probes_sampling_percentage": 1,<br/>  "sampling_percentage": 50<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
