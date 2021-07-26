# All variables
variable "tenancy_ocid" {}
variable "user_ocid" {
  default = "ocid1.user.oc1..aaaaaaaavilbyzfyqbghmp72e74nneycodvchprw2psw4h3e2wamhneg56rq"
}
variable "compartment_ocid" {}
variable "fingerprint" {
  default = "32:25:ec:86:12:e1:62:a2:4f:9e:de:b6:a0:a9:08:64"
}
variable "region" {}
variable "availability_domain_name" {
  default = ""
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "service_ports" {
  default = [80, 443, 22]
}

variable "Subnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "Shape" {
  default = "VM.Standard.E3.Flex"
}

variable "FlexShapeOCUPS" {
  default = 1
}

variable "FlexShapeMemory" {
  default = 4
}

variable "instance_os" {
  default = "Oracle Linux"
}

variable "linux_os_version" {
  default = "7.9"
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
}

# Check if is using Flexible Compute Shapes
locals {
  is_flexible_shape = contains(local.compute_flexible_shapes, var.Shape)
}
