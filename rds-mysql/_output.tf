####### -------------------- RDS ----------------------- #######
output "RDS_Database_Endpoint"  {
  value = aws_db_instance.RDS_DB.endpoint
}