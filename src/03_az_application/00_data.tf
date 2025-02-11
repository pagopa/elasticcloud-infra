data "azuread_client_config" "current" {}

data "azuread_groups" "federated_groups" {
  display_names = var.federated_entra_groups
}
