####### -------------------- ALB ----------------------- #######

/**
  * DNS name from ALB
  * In production, you can add this DNS Name to Route 53 (your domain)
  */
output "ECS_CLUSTER" {
  value = aws_ecs_cluster.ECS_CLUSTER.name
}