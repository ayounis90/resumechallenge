resource "aws_acm_certificate" "cert" {
  provider          = aws.shared
  domain_name       = var.domainName
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "site-validation" {
  provider                = aws.shared
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.resume_cert : record.fqdn]
}