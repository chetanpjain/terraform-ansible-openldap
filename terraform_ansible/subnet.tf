/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1-public" {
    vpc_id = "${aws_vpc.aws-vpc-01.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "Public Subnet"
    }
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-1-private" {
    vpc_id = "${aws_vpc.aws-vpc-01.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags {
        Name = "Private Subnet"
    }
}
