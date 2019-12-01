#storage/main.tf

#create random id 

resource "random_id" "tz_dev_bucket_id" {
  count       = "${var.number_of_instances}"
  byte_length = 2
}

#create bucket

resource "aws_s3_bucket" "tz_dev_code" {
  count         = "${var.number_of_instances}"
  bucket        = "${var.project_name}-${random_id.tz_dev_bucket_id.*.dec[count.index]}"
  acl           = "private"
  force_destroy = false

  tags {
    Name = "tf_bucket${count.index+1}"
  }
}