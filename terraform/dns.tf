resource "aws_route53_zone" "primary" {
    provider = aws.dev
    name = var.domainName
}

