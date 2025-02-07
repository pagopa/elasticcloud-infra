locals {
  policy_files = fileset("${path.module}/default_library/ilm", "*.json")
  ilm_all_policies = {
    for f in local.policy_files :
    trimsuffix(basename(f), ".json") =>
    jsondecode(templatefile("${path.module}/default_library/ilm/${f}", {
      prefix_env_short = local.prefix_env_short
    }))
  }
  ilm_target_policies = {
    for key, policy in local.ilm_all_policies :
    key => policy if contains(values(var.ilm), key)
  }

}

resource "elasticstack_elasticsearch_index_lifecycle" "index_lifecycle" {
  for_each = local.ilm_target_policies

  name = "${local.prefix_env}-${each.key}-ilm"

  hot {
    min_age = each.value.hot.minAge

    rollover {
      max_primary_shard_size = each.value.hot.rollover.maxPrimarySize
      max_age                = each.value.hot.rollover.maxAge
    }
  }

  warm {
    min_age = each.value.warm.minAge

    set_priority {
      priority = each.value.warm.setPriority
    }
  }

  cold {
    min_age = each.value.cold.minAge

    set_priority {
      priority = each.value.cold.setPriority
    }
  }

  delete {
    min_age = each.value.delete.minAge
    dynamic "wait_for_snapshot" {
      for_each = var.ilm_delete_wait_for_snapshot ? [1] : []
      content {
        policy = each.value.delete.waitForSnapshot
      }
    }

    delete {
      delete_searchable_snapshot = each.value.delete.deleteSearchableSnapshot
    }
  }

  metadata = jsonencode({
    "managedBy" = "Terraform"
  })
}
