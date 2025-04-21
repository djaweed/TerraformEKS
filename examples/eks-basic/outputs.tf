
output "eks_cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "node_group_name" {
  value = module.eks_node_group.node_group_name
}

output "aws_lb_controller_status" {
  value = module.eks_addons.aws_lb_controller_status
}

output "metrics_server_status" {
  value = module.eks_addons.metrics_server_status
}
