resource "elasticstack_elasticsearch_snapshot_repository" "snapshot_repository" {
  name = "${local.prefix_env_short}-default-snapshot-backup"

  azure {
    container  = "snapshotblob"
    base_path  = ""
    chunk_size = "32MB"
    compress   = true
    client     = replace(local.prefix_env_short, "-", "")
  }
}


resource "elasticstack_elasticsearch_snapshot_lifecycle" "default_snapshot_policy" {
  count = var.default_snapshot_policy.enabled ? 1 : 0
  name  = "${local.prefix_env_short}-default-nightly-snaapshots"

  schedule      = var.default_snapshot_policy.scheduling
  snapshot_name = "<nightly-snap-{now/d}>"
  repository    = elasticstack_elasticsearch_snapshot_repository.snapshot_repository.name

  indices = [
    "*-${var.prefix}.${var.env}",
    "logs-apm*",
    "traces-apm*",
    "metrics-apm*"
  ]
  ignore_unavailable   = true
  include_global_state = true

  expire_after = var.snapshot_lifecycle_default.expire_after
  min_count    = 5
  max_count    = 50
}
