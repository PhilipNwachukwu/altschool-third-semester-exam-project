# module "grafana_prometheus_monitoring" {
#   source = "git::https://github.com/PhilipNwachukwu/terraform-aws-eks-grafana-prometheus.git"

#   enabled = true
# }

resource "null_resource" "merge_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [module.eks]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      aws eks wait cluster-active --name '${local.cluster_name}'
      aws eks update-kubeconfig --name '${local.cluster_name}' --alias '${local.cluster_name}-${var.region}' --region '${var.region}'
    EOT
  }
}

resource "kubernetes_namespace" "grafana" {
  depends_on = [module.eks]
  metadata {
    name = var.namespace_grafana
  }
}

resource "kubernetes_namespace" "prometheus" {
  depends_on = [module.eks]
  metadata {
    name = var.namespace_prometheus
  }
}


resource "helm_release" "grafana" {
  depends_on = [kubernetes_namespace.grafana]
  name       = var.helm_chart_grafana_name
  chart      = var.helm_chart_grafana_release_name
  repository = var.helm_chart_grafana_repo
  version    = var.helm_chart_grafana_version
  namespace  = var.namespace_grafana

  set {
    name  = "adminPassword"
    value = "admin"
  }

  values = [
    file("${path.module}/grafana.yaml"),
    yamlencode(var.settings_grafana)
  ]

}

resource "helm_release" "prometheus" {
  depends_on = [kubernetes_namespace.prometheus]
  name       = var.helm_chart_prometheus_name
  chart      = var.helm_chart_prometheus_release_name
  repository = var.helm_chart_prometheus_repo
  version    = var.helm_chart_prometheus_version
  namespace  = var.namespace_prometheus

  values = [
    yamlencode(var.settings_prometheus)
  ]

}
