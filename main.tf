resource "azurerm_resource_group" "proj1_westus" {
  name     = "proj1_westus"
  location = "West US"
}

resource "azurerm_resource_group" "proj1_westeuro" {
  name     = "proj1_westeuro"
  location = "West Europe"
}

module "vnet" {
  source     = "./modules/network"
  us_rg_name = azurerm_resource_group.proj1_westus.name
  us_rg_loc  = azurerm_resource_group.proj1_westus.location
  eu_rg_name = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc  = azurerm_resource_group.proj1_westeuro.location
}

module "vms" {
  source        = "./modules/compute"
  us_subnet1_id = module.vnet.us_subnet1_id
  eu_subnet1_id = module.vnet.eu_subnet1_id
  us_rg_name    = azurerm_resource_group.proj1_westus.name
  us_rg_loc     = azurerm_resource_group.proj1_westus.location
  eu_rg_name    = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc     = azurerm_resource_group.proj1_westeuro.location
  student_id    = var.student_id
}