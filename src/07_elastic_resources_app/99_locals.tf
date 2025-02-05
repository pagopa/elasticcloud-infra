locals {
  subscription_prefix = "paymon-${var.env_short}"
  prefix_env          = "${var.prefix}-${var.env}"
  prefix_env_short    = "${var.prefix}-${var.env_short}"

  config_folder_name = "products/${var.prefix}"
  config_files       = fileset(path.module, "${local.config_folder_name}/*/*/appSettings.json")

  configurations = {
    for f in local.config_files : jsondecode(file(f)).id => {
      conf = jsondecode(templatefile(f, {
        prefix            = var.prefix
        env               = var.env
        env_separator     = "${var.env}-"
        wait_for_snapshot = var.lifecycle_policy_wait_for_snapshot
        name              = trimsuffix(basename(f), ".json")
      }))
      space_name       = split("/", dirname(f))[2] #get space name from structure products/<product>/<space_name>/<application_name>
      dashboard_folder = "${dirname(f)}/dashboard"
      query_folder     = "${dirname(f)}/query"
    }
  }
  spaces = toset([for f in local.config_files : split("/", dirname(f))[2]]) #get space name from structure products/<product>/<space_name>/<application_name>

  logs_general_to_exclude_paths = distinct(flatten([
    for instance_name in var.k8s_application_log_instance_names : "'/var/log/containers/${instance_name}-*.log'"
  ]))


  template_resolution_variables = {
    namespace                     = var.elastic_agent_kube_namespace
    dedicated_log_instance_name   = var.k8s_application_log_instance_names
    logs_general_to_exclude_paths = local.logs_general_to_exclude_paths

    system_name            = elasticstack_fleet_integration_policy.system_integration_policy.name
    system_id              = elasticstack_fleet_integration_policy.system_integration_policy.id
    system_package_version = data.elasticstack_fleet_integration.system.version
    system_revision        = 1

    kubernetes_name            = elasticstack_fleet_integration_policy.kubernetes_integration_policy.name
    kubernetes_id              = elasticstack_fleet_integration_policy.kubernetes_integration_policy.id
    kubernetes_package_version = data.elasticstack_fleet_integration.kubernetes.version
    kubernetes_revision        = 1

    apm_name            = elasticstack_fleet_integration_policy.apm_integration_policy.name
    apm_id              = elasticstack_fleet_integration_policy.apm_integration_policy.id
    apm_package_version = data.ec_deployment.ec_deployment.integrations_server[0].version
    apm_revision        = 1


    target           = "${var.prefix}-${var.env}"
    target_namespace = "${var.prefix}.${var.env}"

    elastic_host = replace(data.ec_deployment.ec_deployment.elasticsearch[0].https_endpoint, ".es.", ".")

    elasticsearch_api_key = data.azurerm_key_vault_secret.elasticsearch_api_key.value
    elastic_agent_version = "8.17.1"
  }

}



