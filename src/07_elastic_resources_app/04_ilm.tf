locals {
  policy_files = fileset("${path.module}/default_library/ilm", "*.json")
  ilm_all_policies = {
    for f in local.policy_files :
    trimsuffix(basename(f), ".json") =>
    jsondecode(templatefile("${path.module}/default_library/ilm/${f}", {
      prefix_env_short = local.prefix_env_short
      snapshot_policy  = "${local.prefix_env_short}-default-nightly-snapshots"
    }))
  }
}

resource "elasticstack_elasticsearch_index_lifecycle" "index_lifecycle" {
  for_each = local.ilm_all_policies

  name = "${local.prefix_env}-${each.key}-ilm"

  hot {
    min_age = each.value.hot.minAge

    rollover {
      max_primary_shard_size = each.value.hot.rollover.maxPrimarySize
      min_primary_shard_size = lookup(each.value.hot.rollover, "minPrimarySize", null)
      max_age                = each.value.hot.rollover.maxAge
    }
  }

  warm {
    min_age = each.value.warm.minAge

    set_priority {
      priority = each.value.warm.setPriority
    }

    dynamic "shrink" {
      for_each = lookup(each.value.warm, "shrink", null) != null ? [1] : []

      content {
        allow_write_after_shrink = each.value.warm.shrink.allowWriteAfterShrink
        max_primary_shard_size   = each.value.warm.shrink.maxPrimarySize

      }
    }
  }

  cold {
    min_age = each.value.cold.minAge

    dynamic "allocate" {
      for_each = lookup(each.value.cold, "allocate", null) != null ? [1] : []
      content {
        number_of_replicas = each.value.cold.allocate.numberOfReplicas
      }
    }

    set_priority {
      priority = each.value.cold.setPriority
    }
  }

  delete {
    min_age = each.value.delete.minAge
    dynamic "wait_for_snapshot" {
      for_each = var.ilm_delete_wait_for_snapshot && lookup(each.value.delete, "waitForSnapshot", null) != null ? [1] : []
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
