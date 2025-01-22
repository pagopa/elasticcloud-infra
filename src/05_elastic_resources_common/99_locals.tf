locals {
  admins_email = [
    "marco.mari@pagopa.it",
    "matteo.alongi@pagopa.it",
    "diego.lagosmorales@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "fabio.felici@pagopa.it"
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
      "waitForSnapshot"          = var.lifecycle_policy_wait_for_snapshot
    }
  }
}
