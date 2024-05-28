# local maps
locals {
  local_tags = {
    Application = "${var.APP_NAME}"
    Environment = "${var.ENV_PREFIX}"
  }

  waf_tags = {
    is_AWS_WAFv2_protected_resource = "Block"
  }
}