output "REPOSITORY_URL" {
  description = "The URL of the repository."
  value = "${aws_ecr_repository.ECR_REPOSITORY.repository_url}"
}