# TZ AWS Terraform Infrastructure

This is the initial AWS infrastructure-as-code for Tractor Zoom's development environment. The design is based around a stand-alone VPC with public-private subnet architecture, basic EC2 provisioning, and S3 buckets.

Future iterations will include load balancers, autoscaling groups, content delivery network, and more.

## Organization

The modules are organized into 1) compute, 2) database, 3) networking, and 4) storage folders. 