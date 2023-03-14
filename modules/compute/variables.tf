variable "us_rg_name" {}
variable "us_rg_loc" {}
variable "eu_rg_name" {}
variable "eu_rg_loc" {}
variable "us_subnet1_id" {}
variable "eu_subnet1_id" {}
variable "student_id" {}

variable "vm_names" {
  type    = list(string)
  default = ["r1-VM1", "r1-VM2", "r2-VM3", "r2-VM4"]
}