####### -------------------- ALB ----------------------- #######

/**
  * DNS name from ALB
  * In production, you can add this DNS Name to Route 53 (your domain)
  */
output "ALB_DNS_NAME"  {
  value = aws_alb.ALB.dns_name
}