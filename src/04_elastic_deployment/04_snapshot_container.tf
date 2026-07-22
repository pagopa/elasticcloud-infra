resource "azurerm_resource_group" "ec_rg" {
  for_each = toset(var.shared_env)

  name     = "${each.key}-${var.location_short}-rg"
  location = var.location

  tags = local.tags
}

resource "azurerm_resource_group" "ec_deployment_rg" {
  name     = "${var.prefix}-${var.env_short}-rg"
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

  access_tier = "Cold"

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



# frozen storage account for env specific snapshot repository
resource "azurerm_storage_account" "frozen_env_tier_sa" {
  for_each = toset(var.shared_env)

  name                            = replace(format("%s-ec-frzn-sa", each.key), "-", "")
  resource_group_name             = azurerm_resource_group.ec_rg[each.key].name
  location                        = azurerm_resource_group.ec_rg[each.key].location
  account_tier                    = "Standard"
  account_replication_type        = var.elk_snapshot_sa.replication_type
  allow_nested_items_to_be_public = false

  access_tier = "Hot"

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

resource "azurerm_storage_container" "frozen_container" {
  for_each = toset(var.shared_env)

  name                  = local.frozen_container_name
  storage_account_id    = azurerm_storage_account.frozen_env_tier_sa[each.key].id
  container_access_type = "private"
}


# frozen storage account for deployment wide snapshot repository
resource "azurerm_storage_account" "frozen_deployment_tier_sa" {
  name                            = replace(format("${var.prefix}-${var.env_short}-ec-frzn-sa"), "-", "")
  resource_group_name             = azurerm_resource_group.ec_deployment_rg.name
  location                        = azurerm_resource_group.ec_deployment_rg.location
  account_tier                    = "Standard"
  account_replication_type        = var.elk_snapshot_sa.replication_type
  allow_nested_items_to_be_public = false

  access_tier = "Hot"

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

resource "azurerm_storage_container" "frozen_deployment_container" {
  name                  = local.frozen_container_name
  storage_account_id    = azurerm_storage_account.frozen_deployment_tier_sa.id
  container_access_type = "private"
}