resource "azurerm_network_interface" "name" {
  for_each            = var.vm_names
  name                = "${each.value}-nic1"
  location            = startswith(each.value, "r1") ? us_rg_loc : startswith(each.value, "r2") ? eu_rg_loc : ""
  resource_group_name = startswith(each.value, "r1") ? us_rg_name : startswith(each.value, "r2") ? eu_rg_name : ""

  ip_configuration {
    name               = "internal"
    subnet_id          = startswith(each.value, "r1") ? us_subnet1_id : startswith(each.value, "r2") ? eu_subnet1_id : ""
    private_ip_address = "Dynamic"
  }
}