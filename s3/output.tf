output "user_story_s3_id" {
  description = "S3 bucket for ec2 template"
  value = aws_s3_bucket.bucket_for_ec2.id
}