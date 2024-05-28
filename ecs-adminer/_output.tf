####### -------------------- ALB ----------------------- #######

/**
  * DNS name from ALB
  */
output "ALB_DNS_NAME"  {
  value = aws_alb.ALB.dns_name
}