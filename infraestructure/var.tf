
variable "aws_region" {
  description   = "AWS Region"
  default     = ""
}

variable "env" {
  type   = "string"
  default     = "Course"
}

variable "product" {
  type   = "string"
  default     = ""
}

variable "dir_type" {
  type   = "string"
  default     = "SimpleAD"
}
