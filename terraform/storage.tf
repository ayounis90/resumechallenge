locals {
  resume_files = "../resume"
  mime_types = jsondecode(file("mime.json"))
}

resource "aws_s3_bucket" "resume_challenge" {
  provider = aws.dev
  bucket   = var.bucketName
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset(local.resume_files, "**")
  provider = aws.dev
  bucket   = aws_s3_bucket.resume_challenge.id
  key      = each.key
  source   = "${local.resume_files}/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

resource "aws_s3_bucket_website_configuration" "resume_website_config" {
  provider = aws.dev
  bucket = aws_s3_bucket.resume_challenge.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  provider = aws.dev
  bucket = aws_s3_bucket.resume_challenge.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "resume_challenge_policy" {
  provider = aws.dev
  bucket = aws_s3_bucket.resume_challenge.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketName })
  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
}
