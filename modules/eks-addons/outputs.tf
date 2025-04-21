
output "aws_lb_controller_status" {
  value = helm_release.aws_load_balancer_controller.status
}

output "metrics_server_status" {
  value = helm_release.metrics_server.status
}
