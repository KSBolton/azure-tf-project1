variable "us_rg_name" {}
variable "us_rg_loc" {}
variable "eu_rg_name" {}
variable "eu_rg_loc" {}
variable "us_subnet1_id" {}
variable "eu_subnet1_id" {}
variable "prefix" {}
variable "client_vm_pwd" {}
variable "lnx_vm_config" {}
variable "client_vm_config" {}

variable "vm_names" {
  type    = set(string)
  default = ["r1-VM1", "r1-VM2", "r2-VM3", "r2-VM4"]
}

variable "client_names" {
  type    = set(string)
  default = ["Client_vm_r1", "Client_vm_r2"]
}