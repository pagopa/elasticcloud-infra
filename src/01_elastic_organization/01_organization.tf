resource "ec_organization" "admin_elastic_cloud_organization" {
  members = {
    "marco.mari@pagopa.it" = {
      organization_role = "organization-admin"
    },
    "matteo.alongi@pagopa.it" = {
      organization_role = "organization-admin"
    },
    "umberto.coppolabottazzi@pagopa.it" = {
      organization_role = "organization-admin"
    },
    "fabio.felici@pagopa.it" = {
      organization_role = "organization-admin"
    },
    "diego.lagosmorales@pagopa.it" = {
      organization_role = "organization-admin"
    }
  }
}
