output "bucketname" {
  value = "${join(", ", aws_s3_bucket.tz_dev_code.*.id)}"
}