resource "azurerm_virtual_network" "hub_vnet" {
  name                = "proj1_hub_vnet"
  resource_group_name = var.us_rg_name
  location            = var.us_rg_loc
  address_space       = ["10.0.3.128/26"]
}