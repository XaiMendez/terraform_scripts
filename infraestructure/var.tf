variable "aws_region" {
  description   = "AWS Region"
  default     = ""
}

variable "env" {
  type        = string
  default     = "Course"
}

variable "product" {
  type        = string
  default     = ""
}

variable "dir_type" {
  type        = string
  default     = "SimpleAD"
}

variable "az_names" {
  type        = list(string)
  default     = [""]
}

variable "vpc_cidr" {
  type        = string
}

variable "instance_type" {
  type        = string
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  default     = [""]
}

variable "domain_name" {
  #type        = string
}

variable "allocated_storage" {
  #type        = string
}

variable "engine_name" {
  #type        = string
}

variable "engine_version" {
  #type        = string
}

variable "db_instance_type" {
  #type        = string
}

variable "db_name" {
  #type        = string
}

variable "username" {
  #type        = string
}

variable "password" {
  #type        = string
}
