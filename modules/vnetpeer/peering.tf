# resource "azurerm_resource_group" "vnet_peer_rg" {
#   name = "vnet_peer_rg"
#   location = "West US"
# }

resource "azurerm_virtual_network_peering" "hub_to_usa" {
  name                      = "hub_to_usa"
  resource_group_name       = var.hub_vnet.resource_group_name
  virtual_network_name      = var.hub_vnet.name
  remote_virtual_network_id = var.usa_vnet.id
}

resource "azurerm_virtual_network_peering" "usa_to_hub" {
  name                      = "usa_to_hub"
  resource_group_name       = var.usa_vnet.resource_group_name
  virtual_network_name      = var.usa_vnet.name
  remote_virtual_network_id = var.hub_vnet.id
}

resource "azurerm_virtual_network_peering" "hub_to_euro" {
  name                      = "hub_to_euro"
  resource_group_name       = var.hub_vnet.resource_group_name
  virtual_network_name      = var.hub_vnet.name
  remote_virtual_network_id = var.euro_vnet.id
}

resource "azurerm_virtual_network_peering" "euro_to_hub" {
  name                      = "euro_to_hub"
  resource_group_name       = var.euro_vnet.resource_group_name
  virtual_network_name      = var.euro_vnet.name
  remote_virtual_network_id = var.hub_vnet.id
}