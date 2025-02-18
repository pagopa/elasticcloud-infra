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
| <a name="requirement_elasticstack"></a> [elasticstack](#requirement\_elasticstack) | 0.11.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.17.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.19.0 |
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4 | 659a44db66e6fbfaddd56471a9ee304ac7f074eb |
| <a name="module_install_agent_cluster_1"></a> [install\_agent\_cluster\_1](#module\_install\_agent\_cluster\_1) | ./.terraform/modules/__v4__/elastic_cloud_agent | n/a |
| <a name="module_install_agent_cluster_2"></a> [install\_agent\_cluster\_2](#module\_install\_agent\_cluster\_2) | ./.terraform/modules/__v4__/elastic_cloud_agent | n/a |
| <a name="module_otel_cluster_1"></a> [otel\_cluster\_1](#module\_otel\_cluster\_1) | ./.terraform/modules/__v4__/open_telemetry | n/a |
| <a name="module_otel_cluster_2"></a> [otel\_cluster\_2](#module\_otel\_cluster\_2) | ./.terraform/modules/__v4__/open_telemetry | n/a |

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_security_role.admin_role](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role.editor_role](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role.viewer_role](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role) | resource |
| [elasticstack_elasticsearch_security_role_mapping.admins_as_superuser](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_security_role_mapping.custom_role_mappings](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_security_role_mapping.kibana_admin](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_snapshot_lifecycle.default_snapshot_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_snapshot_lifecycle) | resource |
| [elasticstack_elasticsearch_snapshot_repository.snapshot_repository](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/elasticsearch_snapshot_repository) | resource |
| [elasticstack_fleet_agent_policy.kubernetes_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_agent_policy) | resource |
| [elasticstack_fleet_integration.kubernetes_package](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration) | resource |
| [elasticstack_fleet_integration.system_package](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration) | resource |
| [elasticstack_fleet_integration_policy.apm_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.kubernetes_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
| [elasticstack_fleet_integration_policy.system_integration_policy](https://registry.terraform.io/providers/elastic/elasticstack/0.11.7/docs/resources/fleet_integration_policy) | resource |
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
| <a name="input_aks_config"></a> [aks\_config](#input\_aks\_config) | (Required) list of aks cluster configurations where the elstic agent and otel will be installed. must not be empty, must not be more than 2 elements | <pre>list(object({<br/>    name = string<br/>    elastic_agent = object({<br/>      namespace = string<br/>      create_ns = bool<br/>      tolerated_taints = optional(list(object({<br/>        key    = string<br/>        effect = optional(string, "NoSchedule")<br/>      })), [])<br/>    })<br/>    otel = object({<br/>      namespace = string<br/>      create_ns = bool<br/>      affinity_selector = optional(object({<br/>        key   = string<br/>        value = string<br/>      }), null)<br/>      receiver_port = optional(string, "4317")<br/>    })<br/>  }))</pre> | n/a | yes |
| <a name="input_default_ilm"></a> [default\_ilm](#input\_default\_ilm) | Defines the default Index Lifecycle Management (ILM) policy stages for an Elasticsearch deployment. | `any` | `{}` | no |
| <a name="input_default_snapshot_policy"></a> [default\_snapshot\_policy](#input\_default\_snapshot\_policy) | Defines the properties of the default snapshot policy | <pre>object({<br/>    scheduling = optional(string, "0 30 1 * * ?")<br/>    enabled    = bool<br/>  })</pre> | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | (Required) EC deployment name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_k8s_application_log_instance_names"></a> [k8s\_application\_log\_instance\_names](#input\_k8s\_application\_log\_instance\_names) | (Required) List of app namespaces or pod names for which the elastic agent will send logs | `list(string)` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | (Optional) path to the kube config folder | `string` | `"~/.kube"` | no |
| <a name="input_opentelemetry_operator_helm_version"></a> [opentelemetry\_operator\_helm\_version](#input\_opentelemetry\_operator\_helm\_version) | Open telemetry operator version | `string` | `"0.24.3"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_role_mappings"></a> [role\_mappings](#input\_role\_mappings) | n/a | `map(any)` | `{}` | no |
| <a name="input_snapshot_lifecycle_default"></a> [snapshot\_lifecycle\_default](#input\_snapshot\_lifecycle\_default) | (Required) Identifier for the default snapshot lifecycle policy of the EC deployment. | <pre>object({<br/>    expire_after = string<br/>  })</pre> | <pre>{<br/>  "expire_after": "30d"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
