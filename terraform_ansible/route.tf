resource "aws_route_table" "us-east-1-public" {
    vpc_id = "${aws_vpc.aws-vpc-01.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.aws-igw-01.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-1-public" {
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table" "us-east-1-private" {
    vpc_id = "${aws_vpc.aws-vpc-01.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.aws-igw-01.id}"
    }

    tags {
        Name = "Private Subnet"
        
    }
}

resource "aws_route_table_association" "us-east-1-private" {
    subnet_id = "${aws_subnet.us-east-1-private.id}"
    route_table_id = "${aws_route_table.us-east-1-private.id}"
}
