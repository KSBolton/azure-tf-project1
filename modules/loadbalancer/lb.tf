resource "azurerm_public_ip" "l4_lbs_pip" {
  for_each            = var.lb_names
  location            = startswith(each.value, "r1") ? var.us_rg_loc : startswith(each.value, "r2") ? var.eu_rg_loc : ""
  resource_group_name = startswith(each.value, "r1") ? var.us_rg_name : startswith(each.value, "r2") ? var.eu_rg_name : ""
  allocation_method   = "Dynamic"
  name                = "${each.value}_pip"
  domain_name_label   = "proj1-kbolton3-${replace(each.value, "_", "-")}"
}

resource "azurerm_lb" "l4_lbs" {
  for_each            = var.lb_names
  name                = each.value
  location            = startswith(each.value, "r1") ? var.us_rg_loc : startswith(each.value, "r2") ? var.eu_rg_loc : ""
  resource_group_name = startswith(each.value, "r1") ? var.us_rg_name : startswith(each.value, "r2") ? var.eu_rg_name : ""

  frontend_ip_configuration {
    name                          = "Internal"
    private_ip_address_allocation = "Dynamic"
    # subnet_id                     = startswith(each.value, "r1") ? var.us_subnet1_id : startswith(each.value, "r2") ? var.eu_subnet1_id : ""
    public_ip_address_id = azurerm_public_ip.l4_lbs_pip[each.value].id
  }
}