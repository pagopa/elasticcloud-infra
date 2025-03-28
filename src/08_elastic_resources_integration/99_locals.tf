locals {
  subscription_prefix  = "paymon"
  subscription_product = "${local.subscription_prefix}-${var.env_short}"

  prefix_env = "${var.prefix}-${var.env}"


  azdo_kubernetes_namespace = "elastic-cloud-azdo"
}



