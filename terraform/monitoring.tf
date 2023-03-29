# module "grafana_prometheus_monitoring" {
#   source = "git::https://github.com/PhilipNwachukwu/terraform-aws-eks-grafana-prometheus.git"

#   enabled = true
# }

resource "kubernetes_namespace" "grafana" {
  depends_on = [module.eks.cluster_name]
  count      = (var.enabled && var.create_namespace_grafana && var.namespace_grafana != "kube-system") ? 1 : 0

  metadata {
    name = var.namespace_grafana
  }
}

resource "kubernetes_namespace" "prometheus" {
  depends_on = [module.eks.cluster_name]
  count      = (var.enabled && var.create_namespace_prometheus && var.namespace_prometheus != "kube-system") ? 1 : 0

  metadata {
    name = var.namespace_prometheus
  }
}

resource "helm_release" "grafana" {
  depends_on = [kubernetes_namespace.grafana, ]
  count      = var.enabled ? 1 : 0
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
  depends_on = [kubernetes_namespace.prometheus, ]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_prometheus_name
  chart      = var.helm_chart_prometheus_release_name
  repository = var.helm_chart_prometheus_repo
  version    = var.helm_chart_prometheus_version
  namespace  = var.namespace_prometheus

  values = [
    yamlencode(var.settings_prometheus)
  ]

}
