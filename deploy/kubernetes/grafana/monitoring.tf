
module "grafana_prometheus_monitoring" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-grafana-prometheus.git"

  enabled = true
}
