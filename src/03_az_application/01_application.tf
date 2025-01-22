resource "azuread_application" "ec_application" {
  display_name    = "${local.project}-app"
  identifier_uris = ["api://${local.project}-app"]
  owners          = [data.azuread_client_config.current.object_id]
}

#TODO Associazione tra gruppo AD (creato su eng-azure) con l'application
# Come fare? Vedi https://github.com/pagopa/azuread-tf-modules/blob/main/assign_user_to_service_principal/main.tf
