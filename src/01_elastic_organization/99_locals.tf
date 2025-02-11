locals {
  prefix   = "paymon"
  location = "italynorth"

  project = "${local.prefix}-${var.env_short}-ec-org"
}
