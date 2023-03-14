resource "azurerm_network_interface" "vm_nics" {
  for_each            = var.vm_names
  name                = "${each.value}_nic1"
  location            = startswith(each.value, "r1") ? var.us_rg_loc : startswith(each.value, "r2") ? var.eu_rg_loc : ""
  resource_group_name = startswith(each.value, "r1") ? var.us_rg_name : startswith(each.value, "r2") ? var.eu_rg_name : ""

  ip_configuration {
    name                          = "internal"
    subnet_id                     = startswith(each.value, "r1") ? var.us_subnet1_id : startswith(each.value, "r2") ? var.eu_subnet1_id : ""
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "client_nics" {
  for_each            = var.client_names
  name                = "${each.value}-nic1"
  location            = endswith(each.value, "r1") ? var.us_rg_loc : endswith(each.value, "r2") ? var.eu_rg_loc : ""
  resource_group_name = endswith(each.value, "r1") ? var.us_rg_name : endswith(each.value, "r2") ? var.eu_rg_name : ""

  ip_configuration {
    name                          = "internal"
    subnet_id                     = endswith(each.value, "r1") ? var.us_subnet1_id : endswith(each.value, "r2") ? var.eu_subnet1_id : ""
    private_ip_address_allocation = "Dynamic"
  }
}