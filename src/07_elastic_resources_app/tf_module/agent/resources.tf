
resource "kubernetes_namespace" "agent_namespace" {
  metadata {
    name = var.elastic_agent_kube_namespace
  }
}

resource "kubernetes_manifest" "config_map" {
  depends_on = [kubernetes_namespace.agent_namespace]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/configMap.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "cluster_role_binding" {
  depends_on = [kubernetes_manifest.config_map]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/clusterRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_role_binding" {
  depends_on = [kubernetes_manifest.cluster_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_kubeadmin_role_binding" {
  depends_on = [kubernetes_manifest.elastic_agent_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentKubeAdminRoleBinding.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "cluster_role" {
  depends_on = [kubernetes_manifest.elastic_agent_kubeadmin_role_binding]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/clusterRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_role" {
  depends_on = [kubernetes_manifest.cluster_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "elastic_agent_kubeadmin_role" {
  depends_on = [kubernetes_manifest.elastic_agent_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/elasticAgentKubeAdminRole.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "service_account" {
  depends_on = [kubernetes_manifest.elastic_agent_kubeadmin_role]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/serviceAccount.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "secret_api_key" {
  depends_on = [kubernetes_manifest.service_account]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/secret.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources"]
}

resource "kubernetes_manifest" "daemon_set" {
  depends_on = [kubernetes_manifest.secret_api_key]
  manifest = yamldecode(replace(replace(templatefile("${path.module}/yaml/daemonSet.yaml", local.template_resolution_variables), "/(?s:\nstatus:.*)$/", ""), "0640", "416"))

  field_manager {
    force_conflicts = true
  }
  computed_fields = ["spec.template.spec.containers[0].resources", "metadata.annotations", "spec.template.spec.hostNetwork"]
}