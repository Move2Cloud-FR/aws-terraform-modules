# ECS Fargate Module

## Description
Deploys ECS services using Fargate, behind an Application Load Balancer, with an alias record in Route 53.

## Resources
- ECS service and task definition
- ALB: an HTTP listener on `HTTP_APP_PORT` and an HTTPS listener on `HTTPS_APP_PORT` (certificate `CERTIFICATE_ARN`), forwarding to the service
- Route 53 alias record `RECORD` in `ZONE`
- CloudWatch logs, scheduled auto scaling

## Other addresses (optional)
- `REDIRECT_HOSTS`: other host names the ALB answers for (www, older domains), redirected (301) to `RECORD` with their path and query, by a rule of priority 1 on the HTTPS listener; the forwarding rule then takes priority 100. `CERTIFICATE_ARN` must cover them; their DNS records are made by the caller (they may live in other zones).
- `HTTP_REDIRECT_PORT`: a plain HTTP port (usually 80) answered by a redirect (301) to HTTPS, same host, path and query, and opened in the ALB's security group. It must differ from `HTTP_APP_PORT`.

Both default to nothing: a service that does not set them is unchanged.

## Outputs
- `ALB_DNS_NAME`
- `ECS_SERVICE_NAME`
