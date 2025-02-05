locals {
  subscription_prefix = "paymon-${var.env_short}"
  prefix_env          = "${var.prefix}-${var.env}"
  prefix_env_short    = "${var.prefix}-${var.env_short}"

  config_folder_name = "products/${var.prefix}"
  config_files       = fileset(path.module, "${local.config_folder_name}/*/*/appSettings.json")

  configurations = {
    for f in local.config_files : split("/", dirname(f))[3] => { #get application name from structure products/<product>/<space_name>/<application_name>
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
      application_name = split("/", dirname(f))[3] #get application name from structure products/<product>/<space_name>/<application_name>
    }
  }
  spaces = toset([for f in local.config_files : split("/", dirname(f))[2]]) #get space name from structure products/<product>/<space_name>/<application_name>
}



