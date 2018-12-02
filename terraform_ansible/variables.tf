variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "aws_key_name" {
    description = "key file for instances"
    default = "ldap-cluster"
}

variable "aws_access_key" {
    description = "access key for aws"
    default = "AKIAJI6SNNT2VK5PC34A"
  
}

variable "aws_secret_key" {
    description = "secret key for aws"
    default = "JC3YxhuDbb9XHP2H/C+u/kpcIXOCfgQg3VZGX2OX"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        us-east-1 = "ami-9887c6e7" 
           }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

