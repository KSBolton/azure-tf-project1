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

resource "azurerm_lb_backend_address_pool" "l4_be_pool" {
  for_each = var.lb_names
  name = "${each.value}_be_pool"
  loadbalancer_id = azurerm_lb.l4_lbs[each.value].id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_be_pool_assoc" {
  for_each = var.lnx_vm_nics
  network_interface_id = each.value.id
  ip_configuration_name = "internal"
  backend_address_pool_id = each.value.location == "westus" ? azurerm_lb_backend_address_pool.l4_be_pool[var.r1_lb_name].id : azurerm_lb_backend_address_pool.l4_be_pool[var.r2_lb_name].id
}

resource "azurerm_lb_probe" "l4_lb_probes" {
  for_each = azurerm_lb.l4_lbs
  loadbalancer_id = each.value.id
  name = "http-probe"
  port = 80
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_lb_rule" "l4_lb_rules" {
  for_each = azurerm_lb.l4_lbs
  loadbalancer_id = each.value.id
  name = "${each.value.name}_http_in"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "Internal"
  resource_group_name = each.value.resource_group_name
  backend_address_pool_ids = startswith(azurerm_lb.l4_lbs[each.value.name].name, "r1") ? [azurerm_lb_backend_address_pool.l4_be_pool[var.r1_lb_name].id] : [azurerm_lb_backend_address_pool.l4_be_pool[var.r2_lb_name].id]
  probe_id = startswith(azurerm_lb.l4_lbs[each.value.name].name, "r1") ? azurerm_lb_probe.l4_lb_probes[var.r1_lb_name].id : azurerm_lb_probe.l4_lb_probes[var.r2_lb_name].id
}