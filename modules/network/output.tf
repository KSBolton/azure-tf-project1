output "us_subnet1_id" {
  value = azurerm_subnet.us_subnet.id
}

output "eu_subnet1_id" {
  value = azurerm_subnet.eu_subnet.id
}

output "usa_vnet" {
  value = azurerm_virtual_network.usa_net
}

output "euro_vnet" {
  value = azurerm_virtual_network.euro_net
}