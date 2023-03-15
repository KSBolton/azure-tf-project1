resource "azurerm_lb_backend_address_pool" "l4_be_pool" {
  for_each        = var.lb_names
  name            = "${each.value}_be_pool"
  loadbalancer_id = azurerm_lb.l4_lbs[each.value].id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_be_pool_assoc" {
  for_each                = var.lnx_vm_nics
  network_interface_id    = each.value.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = each.value.location == "westus" ? azurerm_lb_backend_address_pool.l4_be_pool[var.r1_lb_name].id : azurerm_lb_backend_address_pool.l4_be_pool[var.r2_lb_name].id
}