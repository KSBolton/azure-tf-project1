resource "azurerm_network_security_group" "rdp_nsg" {
  count               = 2
  name                = "rdp-nsg"
  location            = count.index == 0 ? var.us_rg_loc : count.index == 1 ? var.eu_rg_loc : ""
  resource_group_name = count.index == 0 ? var.us_rg_name : count.index == 1 ? var.eu_rg_name : ""

  security_rule {
    name                       = "RDP-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "http_nsg" {
  count               = 2
  name                = "http-nsg"
  location            = count.index == 0 ? var.us_rg_loc : count.index == 1 ? var.eu_rg_loc : ""
  resource_group_name = count.index == 0 ? var.us_rg_name : count.index == 1 ? var.eu_rg_name : ""

  security_rule {
    name                       = "HTTP-In"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH-In"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "rdp_nsg_assoc" {
  for_each                  = azurerm_network_interface.client_nics
  network_interface_id      = each.value.id
  network_security_group_id = can(regex("([A-Z])\\w*r1-\\w*", each.value.name)) ? azurerm_network_security_group.rdp_nsg[0].id : azurerm_network_security_group.rdp_nsg[1].id
}

resource "azurerm_network_interface_security_group_association" "http_nsg_assoc" {
  for_each                  = azurerm_network_interface.vm_nics
  network_interface_id      = each.value.id
  network_security_group_id = startswith(each.value.name, "r1") ? azurerm_network_security_group.http_nsg[0].id : azurerm_network_security_group.http_nsg[1].id
}