# Create s3 Bucket
resource "aws_s3_bucket" "bucket_for_ec2" {
  bucket = "aws-s3-bucket-for-ec2-vbazh"
}

# Upload files to s3 Bucket
resource "aws_s3_object" "provision_source_files" {
  bucket = aws_s3_bucket.bucket_for_ec2.id
  for_each = fileset("data_for_ec2_instance_template/", "*")
  key = each.value
  source = "data_for_ec2_instance_template/${each.value}"
  etag = filemd5("data_for_ec2_instance_template/${each.value}")
}