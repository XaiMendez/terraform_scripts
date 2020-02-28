variable "region" {
	default = "us-east-2"
}

variable "amis" {
	default = {
		us-east-2 = "amiID"
	}
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
	default = "10.0.30.0/24"
}


variable "private_subnet_cidr" {
	default = "10.0.40.0/24"
}
