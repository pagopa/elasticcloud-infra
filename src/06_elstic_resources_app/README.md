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

for details on how to configure a new space/application, please refer to the `config` folder README


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
| <a name="provider_ec"></a> [ec](#provider\_ec) | 0.12.2 |
| <a name="provider_elasticstack"></a> [elasticstack](#provider\_elasticstack) | 0.11.13 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_resources"></a> [app\_resources](#module\_app\_resources) | ./tf_module/app_resources | n/a |

## Resources

| Name | Type |
|------|------|
| [elasticstack_kibana_space.kibana_space](https://registry.terraform.io/providers/elastic/elasticstack/latest/docs/resources/kibana_space) | resource |
| [ec_deployment.ec_deployment](https://registry.terraform.io/providers/elastic/ec/latest/docs/data-sources/deployment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_snapshot_policy_name"></a> [default\_snapshot\_policy\_name](#input\_default\_snapshot\_policy\_name) | (Required) default snapshot policy name | `string` | `"default-nightly-snapshots"` | no |
| <a name="input_ec_deployment_id"></a> [ec\_deployment\_id](#input\_ec\_deployment\_id) | (Required) identifier of EC deployment | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_lifecycle_policy_wait_for_snapshot"></a> [lifecycle\_policy\_wait\_for\_snapshot](#input\_lifecycle\_policy\_wait\_for\_snapshot) | (Optional) True if the index lifecycle policy has to wait for snapshots before deletion | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
