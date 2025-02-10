resource "random_uuid" "user_role_uid" {
}

resource "azuread_application" "ec_application" {
  display_name    = "${local.project}-app"
  identifier_uris = ["api://${local.project}"]
  owners          = [data.azuread_client_config.current.object_id]

  optional_claims {
    saml2_token {
      additional_properties = []
      essential             = true
      name                  = "groups"
      source                = "user"
    }

    saml2_token {
      additional_properties = []
      essential             = true
      name                  = "userprincipalname"
      source                = "user"
    }
  }

  group_membership_claims = [
    "ApplicationGroup"
  ]

  feature_tags {
    enterprise            = true
    custom_single_sign_on = true
  }

  web {
    homepage_url  = local.kibana_url
    logout_url    = "${local.kibana_url}/logout"
    redirect_uris = ["${local.kibana_url}/api/security/saml/callback"]
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "User of elastic cloud app"
    display_name         = "User"
    id                   = random_uuid.user_role_uid.result
  }

}


resource "azuread_service_principal" "ec_application_principal" {
  client_id                     = azuread_application.ec_application.client_id
  app_role_assignment_required  = false
  owners                        = [data.azuread_client_config.current.object_id]
  preferred_single_sign_on_mode = "saml"
}

resource "azuread_service_principal_token_signing_certificate" "sso_certificate" {
  service_principal_id = azuread_service_principal.ec_application_principal.id
  display_name         = "CN=Microsoft Azure Federated SSO Certificate"
  # now + 1 year
  end_date = timeadd(timestamp(), "8760h")
}



resource "azuread_app_role_assignment" "app_role_group" {
  for_each = toset(data.azuread_groups.federated_groups.object_ids
  )
  app_role_id         = random_uuid.user_role_uid.result
  principal_object_id = each.value
  resource_object_id  = azuread_service_principal.ec_application_principal.object_id
}