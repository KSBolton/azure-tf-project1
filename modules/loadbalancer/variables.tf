variable "us_rg_name" {}
variable "us_rg_loc" {}
variable "eu_rg_name" {}
variable "eu_rg_loc" {}
variable "us_subnet1_id" {}
variable "eu_subnet1_id" {}
variable "lnx_vm_nics" {}

variable "lb_names" {
  type = set(string)
  default = [ "r1_us_lb1", "r2_eu_lb1" ]
}

variable "r1_lb_name" {
  default = "r1_us_lb1"
}

variable "r2_lb_name" {
  default = "r2_eu_lb1"
}