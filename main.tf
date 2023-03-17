resource "azurerm_resource_group" "proj1_westus" {
  name     = "proj1_westus"
  location = "West US"
}

resource "azurerm_resource_group" "proj1_westeuro" {
  name     = "proj1_westeuro"
  location = "West Europe"
}

module "network" {
  source     = "./modules/network"
  us_rg_name = azurerm_resource_group.proj1_westus.name
  us_rg_loc  = azurerm_resource_group.proj1_westus.location
  eu_rg_name = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc  = azurerm_resource_group.proj1_westeuro.location
}

module "keyvault" {
  source = "./modules/keyvault"
}

module "compute" {
  source        = "./modules/compute"
  us_subnet1_id = module.network.us_subnet1_id
  eu_subnet1_id = module.network.eu_subnet1_id
  us_rg_name    = azurerm_resource_group.proj1_westus.name
  us_rg_loc     = azurerm_resource_group.proj1_westus.location
  eu_rg_name    = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc     = azurerm_resource_group.proj1_westeuro.location
  prefix    = var.prefix
  client_vm_pwd = module.keyvault.client_vm_pwd
  lnx_vm_config = var.lnx_vm_config
  client_vm_config = var.client_vm_config
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
  us_subnet1_id = module.network.us_subnet1_id
  eu_subnet1_id = module.network.eu_subnet1_id
  us_rg_name    = azurerm_resource_group.proj1_westus.name
  us_rg_loc     = azurerm_resource_group.proj1_westus.location
  eu_rg_name    = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc     = azurerm_resource_group.proj1_westeuro.location 
  lnx_vm_nics   = module.compute.lnx_vm_nics
}

# module "appgateway" {
#   source = "./modules/appgateway"
#   lnx_vm_nics   = module.compute.lnx_vm_nics  
#   proj1_rg = azurerm_resource_group.project1
# }

module "vnetpeer" {
  source = "./modules/vnetpeer"
  usa_vnet = module.network.usa_vnet
  euro_vnet = module.network.euro_vnet
  hub_vnet = module.loadbalancer.hub_vnet
}