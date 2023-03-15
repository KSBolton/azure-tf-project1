resource "azurerm_lb" "l4_lbs" {
  for_each = var.lb_names
  name                = each.value
  location            = startswith(each.value, "r1") ? var.us_rg_loc : startswith(each.value, "r2") ? var.eu_rg_loc : ""
  resource_group_name = startswith(each.value, "r1") ? var.us_rg_name : startswith(each.value, "r2") ? var.eu_rg_name : ""

  frontend_ip_configuration {
    name = "Internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id = startswith(each.value, "r1") ? var.us_subnet1_id : startswith(each.value, "r2") ? var.eu_subnet1_id : ""
  }
}