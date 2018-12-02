resource "aws_instance" "aws-ldap-slave" {
    count=2
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
       Name = "aws-ldap-slave-${count.index}",
       sshkey = "${var.aws_key_name}",
       sshuser = "centos"
    }
}
resource "null_resource" "provisioning-slave" {
        #count=2

        connection {
        host = "${element(aws_instance.aws-ldap-slave.*.public_ip, count.index)}"
        type = "ssh"
        user = "centos"
        private_key = "${file("${var.aws_key_name}")}"
        agent = false
      }
     provisioner "file" {
      source = "${var.aws_key_name}"
      destination = "/tmp/sshkey"
    }
    }
