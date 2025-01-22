resource "elasticstack_elasticsearch_snapshot_repository" "snapshot_repository" {
  for_each = toset(var.shared_env)
  name     = "${each.key}-${var.env_short}-default-snapshot-backup"

  azure {
    container  = "snapshotblob"
    base_path  = ""
    chunk_size = "32MB"
    compress   = true
    client     = each.key #TODO Verificare che non si rompa per il trattino
  }
}

resource "elasticstack_elasticsearch_snapshot_lifecycle" "default_snapshot_policy" {
  for_each = toset(var.shared_env)
  # TODO Le configurazioni devono essere environment dipendenti
  name = "${each.key}-${var.env_short}-default-nightly-snapshots"

  schedule      = "0 30 1 * * ?"
  snapshot_name = "<nightly-snap-{now/d}>"
  repository    = elasticstack_elasticsearch_snapshot_repository.snapshot_repository[each.key].name

  indices              = ["*"]
  ignore_unavailable   = true
  include_global_state = true

  expire_after = "30d"
  min_count    = 5
  max_count    = 50
}
