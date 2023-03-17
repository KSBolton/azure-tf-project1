resource "azurerm_lb_rule" "l4_lb_rules" {
  for_each                       = azurerm_lb.l4_lbs
  loadbalancer_id                = each.value.id
  name                           = "${each.value.name}_http_in"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "Internal"
  resource_group_name            = each.value.resource_group_name
  backend_address_pool_ids       = startswith(azurerm_lb.l4_lbs[each.value.name].name, "r1") ? [azurerm_lb_backend_address_pool.l4_be_pool[var.r1_lb_name].id] : [azurerm_lb_backend_address_pool.l4_be_pool[var.r2_lb_name].id]
  probe_id                       = startswith(azurerm_lb.l4_lbs[each.value.name].name, "r1") ? azurerm_lb_probe.l4_lb_probes[var.r1_lb_name].id : azurerm_lb_probe.l4_lb_probes[var.r2_lb_name].id
}