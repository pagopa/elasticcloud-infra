resource "azurerm_storage_account" "state_storage" {
  for_each = toset(var.targets)

  name                            = replace("${each.key}-${var.env}-ec-state", "-", "")
  resource_group_name             = local.terraform_state_rg
  location                        = local.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  allow_nested_items_to_be_public = false

  blob_properties {
    change_feed_enabled = "true"
    container_delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }

  tags = merge(
    var.tags, {
      "SecondaryOwner" : each.key
    }
  )
}

resource "azurerm_storage_container" "state_storage_container" {
  for_each = toset(var.targets)

  name                  = local.terraform_state_container_name
  storage_account_name  = azurerm_storage_account.state_storage[each.key].name
  container_access_type = "private" #TODO Da capire se va bene!
}
