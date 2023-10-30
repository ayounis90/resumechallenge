
resource "aws_route53_zone" "primary" {
  provider = aws.shared
  name     = var.domainName
}

resource "aws_route53domains_registered_domain" "primary_domain" {
  provider = aws.shared
  domain_name = var.domainName
  
  name_server {
    name = element(aws_route53_zone.primary.name_servers, 1)
  }
  name_server {
    name = element(aws_route53_zone.primary.name_servers, 2)
  } 
  name_server {
    name = element(aws_route53_zone.primary.name_servers, 3)
  } 
  name_server {
    name = element(aws_route53_zone.primary.name_servers, 4)
  }

  #depends_on = [ aws_route53_zone.primary ]  
}

resource "aws_route53_record" "resume_cert" {
  provider = aws.shared
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id

  depends_on = [ aws_route53domains_registered_domain.primary_domain ]
}

resource "aws_route53_record" "a" {
  provider = aws.shared
  zone_id  = aws_route53_zone.primary.id
  name     = var.domainName
  type     = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}