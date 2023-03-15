resource "azurerm_availability_set" "lnx_vm_avset" {
  count               = 2
  name                = count.index == 0 ? "lnx_us_vm_av_set" : count.index == 1 ? "lnx_eu_vm_av_set" : ""
  location            = count.index == 0 ? var.us_rg_loc : count.index == 1 ? var.eu_rg_loc : ""
  resource_group_name = count.index == 0 ? var.us_rg_name : count.index == 1 ? var.eu_rg_name : ""
}