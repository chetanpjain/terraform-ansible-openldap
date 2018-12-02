resource "aws_internet_gateway" "aws-igw-01" {
    vpc_id = "${aws_vpc.aws-vpc-01.id}"
}
