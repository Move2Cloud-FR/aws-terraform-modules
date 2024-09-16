####### -------------------- RDS ----------------------- #######
output "RDS_Database_Endpoint"  {
  value = aws_db_instance.RDS_DB.endpoint
}

output "RDS_Database_User"  {
  value = aws_db_instance.RDS_DB.username
}

output "RDS_Database_Password"  {
  value = aws_db_instance.RDS_DB.password
}

output "RDS_Database_DB"  {
  value = aws_db_instance.RDS_DB.db_name
}