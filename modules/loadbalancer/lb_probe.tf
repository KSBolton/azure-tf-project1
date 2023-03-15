resource "azurerm_lb_probe" "l4_lb_probes" {
  for_each            = azurerm_lb.l4_lbs
  loadbalancer_id     = each.value.id
  name                = "http-probe"
  port                = 80
  resource_group_name = each.value.resource_group_name
}