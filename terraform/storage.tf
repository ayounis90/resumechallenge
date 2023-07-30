locals {
  resume_files = "../resume"
  mime_types   = jsondecode(file("mime.json"))
}

resource "aws_s3_bucket" "resume_challenge" {
  provider      = aws.dev
  bucket        = var.bucketName
  force_destroy = true
}

resource "aws_s3_object" "upload_assets" {
  for_each     = fileset(local.resume_files, "**")
  provider     = aws.dev
  bucket       = aws_s3_bucket.resume_challenge.id
  key          = each.key
  source       = "${local.resume_files}/${each.value}"
  etag         = filemd5("${local.resume_files}/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}


#resource "aws_s3_bucket_website_configuration" "resume_website_config" {
#  provider = aws.dev
#  bucket   = aws_s3_bucket.resume_challenge.id
#  index_document {
#    suffix = "index.html"
#  }
#}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  provider = aws.dev
  bucket   = aws_s3_bucket.resume_challenge.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# create bucket ACL:
resource "aws_s3_bucket_acl" "bucket_acl" {
  provider   = aws.dev
  bucket     = aws_s3_bucket.resume_challenge.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  provider = aws.dev
  bucket   = aws_s3_bucket.resume_challenge.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "resume_challenge_policy" {
  provider   = aws.dev
  bucket     = aws_s3_bucket.resume_challenge.id
  policy     = templatefile("s3-policy.json", { bucket = var.bucketName, cloudfront_arn = aws_cloudfront_distribution.s3_distribution.arn })
  depends_on = [aws_s3_bucket_public_access_block.block_public_access]
}
