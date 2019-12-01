#-----compute/outputs.tf

output "server_id" {
  value = "${join(", ", aws_instance.tz_dev_server.*.id)}"
}

output "server_ip" {
  value = "${join(", ", aws_instance.tz_dev_server.*.public_ip)}"
}