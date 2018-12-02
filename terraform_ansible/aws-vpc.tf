resource "aws_vpc" "aws-vpc-01" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "aws-vpc"
    }
}
