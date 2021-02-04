output "autoscaling_group_name" {
  value = aws_autoscaling_group.autoscaling_group.name
}
output "load_balancers_url" {
  value = aws_lb.lb.dns_name
}
