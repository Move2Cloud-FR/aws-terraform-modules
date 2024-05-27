resource "aws_dynamodb_table" "dbtable" {
  name           = "${var.DB_TABLE_NAME}"
  billing_mode   = "PROVISIONED"
  read_capacity  = var.AUTOSCALE_MIN_READ_CAPACITY
  write_capacity = var.AUTOSCALE_MIN_WRITE_CAPACITY
  attribute {
    name = "id"
    type = "S"
  }
  
  hash_key = "id"
  
  // adding the TTL on DynamoDB Table
  ttl {
    enabled        = true      // enabling TTL
    attribute_name = "created" // the attribute name which enforces TTL, must be a Number (Timestamp)
  }
  
  // configuring Point in Time Recovery 
  point_in_time_recovery {
    enabled = true
  }
  
  // configure encryption at REST
  server_side_encryption {
    enabled = true // false -> use AWS Owned CMK, true -> use AWS Managed CMK, true + key arn -> use custom key
  }

  lifecycle {
    ignore_changes = [
      write_capacity, read_capacity
    ]
  }
}
