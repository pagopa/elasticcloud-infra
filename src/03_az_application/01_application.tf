resource "azuread_application" "ec_application" {
  display_name    = "${local.project}-app"
  identifier_uris = [local.kibana_url]
  owners          = [data.azuread_client_config.current.object_id]

   web {
    homepage_url  = "${local.kibana_url}"
    logout_url    = "${local.kibana_url}/logout"
    redirect_uris = ["${local.kibana_url}/api/security/saml/callback"]
  }
}

resource "azuread_service_principal" "ec_application_principal" {
  client_id                    = azuread_application.ec_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

#TODO Associazione tra gruppo AD (creato su eng-azure) con l'application
# Come fare? Vedi https://github.com/pagopa/azuread-tf-modules/blob/main/assign_user_to_service_principal/main.tf
