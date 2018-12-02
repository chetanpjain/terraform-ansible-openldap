resource "aws_instance" "aws-ldap-master" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "aws-ldap-master",
        sshkey = "${var.aws_key_name}",
        sshuser = "centos"
    }
/*
    lifecycle {
    prevent_destroy = true
    }
*/
    provisioner "file" {
      source = "${var.aws_key_name}"
      destination = "/tmp/sshkey"
    }
    #provisioner "file" {
     # source = "./ansible_playbook/"
      #destination = "/tmp"
    #}
    provisioner "remote-exec" {
    inline = [
      "sudo yum install -y epel-release*",
      "sudo yum install -y ansible*",
    ]
  }

      connection {
        host = "${aws_instance.aws-ldap-master.public_ip}"
        type = "ssh"
        user = "centos"
        private_key = "${file("${var.aws_key_name}")}"
        agent = false
      }
}
