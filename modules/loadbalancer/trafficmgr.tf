resource "azurerm_traffic_manager_profile" "proj1_tm_profile" {
  name                   = "kbolton3-tm"
  resource_group_name    = var.us_rg_name
  traffic_routing_method = "Geographic"

  dns_config {
    relative_name = "kbolton3-tm"
    ttl           = 150
  }

  monitor_config {
    protocol = "HTTP"
    port     = 80
    path     = "/"
  }
}

data "azurerm_traffic_manager_geographical_location" "europe" {
  name = "Europe"
}

data "azurerm_traffic_manager_geographical_location" "north_america" {
  name = "North America / Central America / Caribbean"
}

resource "azurerm_traffic_manager_azure_endpoint" "proj1_tm_endpoints" {
  for_each           = azurerm_lb.l4_lbs
  name               = "tm_ep_${each.value.name}"
  profile_id         = azurerm_traffic_manager_profile.proj1_tm_profile.id
  target_resource_id = azurerm_public_ip.l4_lbs_pip[each.value.name].id
  geo_mappings       = startswith(each.value.name, "r1") ? [data.azurerm_traffic_manager_geographical_location.north_america.id] : [data.azurerm_traffic_manager_geographical_location.europe.id]
  weight             = 100
}