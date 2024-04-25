# Create s3 Bucket
resource "aws_s3_bucket" "bucket_for_ec2" {
  bucket = "aws-s3-bucket-for-ec2-vbazh"
}

# Upload files to s3 Bucket
resource "aws_s3_object" "provision_source_files" {
  bucket = aws_s3_bucket.bucket_for_ec2.id
  for_each = fileset("bucket_for_ec2_instances/", "*")
  key = each.value
  source = "bucket_for_ec2_instances/${each.value}"
  etag = filemd5("bucket_for_ec2_instances/${each.value}")
}