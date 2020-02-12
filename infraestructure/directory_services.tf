resource "aws_directory_service_directory" "dev_ad" {
  name = var.domain_name

  # don't change this or parameterize this as it will destroy the existing AD. Update it directly on AD & in "domain_pwd" variable in Terraform
  password = "InfraCourse!23"

  #short_name="${var.short_name}"
  edition     = "Standard"
  description = "InfraAD"

  vpc_settings {
    vpc_id = aws_vpc.DEV_01_VPC.id

    subnet_ids = [
      aws_subnet.DEV_01_PRIVATE_SUBNET.id,
      aws_subnet.DEV_01_PUBLIC_SUBNET.id,
    ]
  }

  type = var.dir_type

  lifecycle {
    ignore_changes = [
      # Ignore changes to edition, Because for some reason it wants to recreat it always
      edition,
    ]
  }
}
