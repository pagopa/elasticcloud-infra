locals {
  policy_files = fileset("${path.module}/custom_resources/ilm", "*.json")
  ilm_all_policies = {
    for f in local.policy_files :
    trimsuffix(basename(f), ".json") =>
    jsondecode(templatefile("${path.module}/custom_resources/ilm/${f}", {
      prefix_env_short = local.prefix_env_short
      snapshot_policy  = "${local.prefix_env_short}-default-nightly-snapshots"
    }))
  }
}

# kept for backward compatibility
# the policy name not containing "deployment" is deprecated, should be kept until all indices using it are deleted, then it can be removed
resource "elasticstack_elasticsearch_index_lifecycle" "index_lifecycle" {
  for_each = local.ilm_all_policies

  name = "${local.prefix_env}-${each.key}-ilm"

  hot {
    min_age = each.value.hot.minAge

    rollover {
      max_primary_shard_size = each.value.hot.rollover.maxPrimarySize
      min_primary_shard_size = each.value.hot.rollover.minPrimarySize
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

    delete {
      delete_searchable_snapshot = each.value.delete.deleteSearchableSnapshot
    }

    dynamic "wait_for_snapshot" {
      for_each = var.ilm_delete_wait_for_snapshot ? [1] : []
      content {
        policy = each.value.delete.waitForSnapshot
      }
    }
  }

  metadata = jsonencode({
    "managedBy" = "Terraform"
  })
}


# new ilm naming convention; uses ilm_prefix which contains the "deployment" string
# name changed to avoid conflicts with ilm defined in 07_elastic_resources_app
resource "elasticstack_elasticsearch_index_lifecycle" "deployment_index_lifecycle" {
  for_each = local.ilm_all_policies

  name = "${local.ilm_prefix}-${each.key}-ilm"

  hot {
    min_age = each.value.hot.minAge

    rollover {
      max_primary_shard_size = each.value.hot.rollover.maxPrimarySize
      min_primary_shard_size = each.value.hot.rollover.minPrimarySize
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

    delete {
      delete_searchable_snapshot = each.value.delete.deleteSearchableSnapshot
    }

    dynamic "wait_for_snapshot" {
      for_each = var.ilm_delete_wait_for_snapshot ? [1] : []
      content {
        policy = each.value.delete.waitForSnapshot
      }
    }
  }

  metadata = jsonencode({
    "managedBy" = "Terraform"
  })
}
