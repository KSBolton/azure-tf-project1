resource "azurerm_subnet" "us_subnet" {
  name                 = "us_subnet1"
  resource_group_name  = var.us_rg_name
  virtual_network_name = azurerm_virtual_network.usa_net.name
  address_prefixes     = ["10.0.3.0/27"]
}

resource "azurerm_subnet" "eu_subnet" {
  name                 = "eu_subnet1"
  resource_group_name  = var.eu_rg_name
  virtual_network_name = azurerm_virtual_network.euro_net.name
  address_prefixes     = ["10.0.3.64/27"]
}