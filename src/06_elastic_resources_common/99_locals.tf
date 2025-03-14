locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  prefix_env        = "${var.prefix}-${var.env}"
  elastic_namespace = "${var.prefix}.${var.env}"
  prefix_env_short  = "${var.prefix}-${var.env_short}"

  apm_indices = [
    "traces-apm*-${local.elastic_namespace}", "traces-*.otel-*-${local.elastic_namespace}", "logs-apm*-${local.elastic_namespace}", "apm-*-${local.elastic_namespace}", "logs-*.otel-*-${local.elastic_namespace}", "metrics-apm*-${local.elastic_namespace}", "metrics-*.otel-*-${local.elastic_namespace}"
  ]

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "PAY-MONITORING"
    Source      = "https://github.com/pagopa/elasticcloud-infra"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  }

  admins_email = [
    "marco.mari@pagopa.it",
    "matteo.alongi@pagopa.it",
    "diego.lagosmorales@pagopa.it",
    "fabio.felici@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it"
  ]

  ilm = lookup(var.default_ilm, "ilm", local.default_ilm)

  default_ilm = {
    "hot" = {
      "minAge" = "0m",
      "rollover" = {
        "maxPrimarySize" = "50gb",
        "maxAge"         = "2d"
      }
    },
    "warm" = {
      "minAge"      = "2d",
      "setPriority" = 50
    },
    "cold" = {
      "minAge"      = "4d",
      "setPriority" = 0
    },
    "delete" = {
      "minAge"                   = "7d",
      "deleteSearchableSnapshot" = true,
      "waitForSnapshot"          = true
    }
  }

  azdo_kubernetes_namespace = "elastic-cloud-azdo"
}
