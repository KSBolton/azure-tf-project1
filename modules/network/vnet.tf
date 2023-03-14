resource "azurerm_virtual_network" "usa_net" {
  name                = "westus_vnet"
  address_space       = ["10.0.3.0/26"]
  location            = var.us_rg_loc
  resource_group_name = var.us_rg_name
}

resource "azurerm_virtual_network" "euro_net" {
  name                = "westeuro_vnet"
  address_space       = ["10.0.3.64/26"]
  location            = var.eu_rg_loc
  resource_group_name = var.eu_rg_name
}