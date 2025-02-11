resource "azurerm_resource_group" "ec_rg" {
  for_each = toset(var.shared_env)

  name     = "${each.key}-${var.location_short}-rg"
  location = var.location

  tags = local.tags
}

resource "azurerm_storage_account" "ec_snapshot_sa" {
  for_each = toset(var.shared_env)

  name                            = replace(format("%s-ec-snap-sa", each.key), "-", "")
  resource_group_name             = azurerm_resource_group.ec_rg[each.key].name
  location                        = azurerm_resource_group.ec_rg[each.key].location
  account_tier                    = "Standard"
  account_replication_type        = var.elk_snapshot_sa.replication_type
  allow_nested_items_to_be_public = false

  blob_properties {
    change_feed_enabled = var.elk_snapshot_sa.backup_enabled
    dynamic "container_delete_retention_policy" {
      for_each = var.elk_snapshot_sa.backup_enabled ? [1] : []
      content {
        days = var.elk_snapshot_sa.blob_delete_retention_days
      }

    }
    versioning_enabled = var.elk_snapshot_sa.backup_enabled
    dynamic "delete_retention_policy" {
      for_each = var.elk_snapshot_sa.backup_enabled ? [1] : []
      content {
        days = var.elk_snapshot_sa.blob_delete_retention_days
      }

    }
  }

  tags = local.tags
}

resource "azurerm_storage_container" "snapshot_container" {
  for_each = toset(var.shared_env)

  name                  = local.default_snapshot_container_name
  storage_account_name  = azurerm_storage_account.ec_snapshot_sa[each.key].name
  container_access_type = "private"
}


