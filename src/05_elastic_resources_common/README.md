# elastic cloud resources

## EC deployment id

Before running this module you need to configure the elastic cloud deployment id for your target environment using the variable
`ec_deployment_id`. The deployment id can be found in the elastic cloud console

### The deployment is shared between DEV and UAT environment. this meta environment is caled TEST

## Elasticsearch api key
in order to use the "elasticstack" provider you need to configure your kibana api key in your system [guide here](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs#environment-variables)

The recommended solution is to define environment variables as follows
```commandline
export ELASTICSEARCH_API_KEY=<deployment api key from kibana portal>
```
**NOTE**: this is different from the elastic cloud api key

## Snapshot repository setup
Before executing this module you need to define some properties in the elasticsearch keystore via elastic cloud portal:

| Name | Value |
|------|---------|
| `azure.client.<clientName>.account` | `<storage account name>` |
| `azure.client.<clientName>.endpoint_suffix`| `blob.core.windows.net` |
| `azure.client.<clientName>.key` | `<storage account access key>` |

these values are required to properly configure a snapshot repository client.
`clientName` is an arbitrary name assigned to the client, it must be different between the environments

- [how to configure anzure blob storage snapshot repo](https://www.elastic.co/guide/en/cloud/current/ec-azure-snapshotting.html)
- [more details on azure repository](https://www.elastic.co/guide/en/elasticsearch/reference/8.17/repository-azure.html)

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.16 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | ~> 0.12.2 |
| <a name="requirement_elasticstack"></a> [elasticstack](#requirement\_elasticstack) | ~> 0.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ec"></a> [ec](#provider\_ec) | ~> 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | ~> 0.11 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [elasticstack_elasticsearch_index_lifecycle.index_lifecycle](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_index_lifecycle) | resource |
| [elasticstack_elasticsearch_security_role_mapping.admins_as_superuser](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_security_role_mapping.application_users_as_kibana_admin](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_security_role_mapping) | resource |
| [elasticstack_elasticsearch_snapshot_lifecycle.default_snapshot_policy](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_snapshot_lifecycle) | resource |
| [elasticstack_elasticsearch_snapshot_repository.snapshot_repository](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/elasticsearch_snapshot_repository) | resource |
| [ec_deployment.ec_deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_ilm"></a> [default\_ilm](#input\_default\_ilm) | Defines the default Index Lifecycle Management (ILM) policy stages for an Elasticsearch deployment. | `any` | `{}` | no |
| <a name="input_ec_deployment_id"></a> [ec\_deployment\_id](#input\_ec\_deployment\_id) | (Required) identifier of EC deployment | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_snapshot_lifecycle_default"></a> [snapshot\_lifecycle\_default](#input\_snapshot\_lifecycle\_default) | (Required) Identifier for the default snapshot lifecycle policy of the EC deployment. | <pre>object({<br/>    expire_after = string<br/>  })</pre> | <pre>{<br/>  "expire_after": "30d"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
