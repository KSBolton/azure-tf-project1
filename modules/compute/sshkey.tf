resource "azurerm_ssh_public_key" "vm_pub_key" {
  count               = 2
  name                = count.index == 0 ? "lnx_us_vm_pub_key" : count.index == 1 ? "lnx_eu_vm_pub_key" : ""
  location            = count.index == 0 ? var.us_rg_loc : count.index == 1 ? var.eu_rg_loc : ""
  resource_group_name = count.index == 0 ? var.us_rg_name : count.index == 1 ? var.eu_rg_name : ""
  public_key          = file("./key-clo800.pub")
}