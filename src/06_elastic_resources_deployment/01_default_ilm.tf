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

  ilm_custom_policy = {
    elastic = {
      snapshot_policy = "cloud-snapshot-policy"
      ilm             = var.default_ilm_elastic
    }
    metricbeat = {
      snapshot_policy = "cloud-snapshot-policy"
      ilm             = var.default_ilm_metricbeat
    }
    elastic_monitoring = {
      snapshot_policy = "cloud-snapshot-policy"
      ilm             = var.default_ilm_elastic_monitoring
    }
  }

  ilm_custom_policies = {
    for k, v in local.ilm_custom_policy :
    k => jsondecode(templatefile("${path.module}/custom_resources/ilm/${v.ilm}.json", {
      prefix_env_short = local.prefix_env_short
      snapshot_policy  = v.snapshot_policy
    }))
  }

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
        number_of_shards         = each.value.warm.shrink.numberOfShards
      }
    }
  }

  dynamic "cold" {
    for_each = lookup(each.value, "cold", null) != null ? [1] : []
    content {
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



resource "elasticstack_elasticsearch_index_lifecycle" "custom_index_lifecycle" {
  for_each = local.ilm_custom_policies

  name = "${local.ilm_prefix}-${each.key}-ilm"

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
  }

  dynamic "cold" {
    for_each = lookup(each.value, "cold", null) != null ? [1] : []
    content {
      min_age = each.value.cold.minAge

      set_priority {
        priority = each.value.cold.setPriority
      }
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