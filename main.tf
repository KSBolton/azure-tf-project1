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

module "keyvault" {
  source = "./modules/keyvault"
}

module "compute" {
  source        = "./modules/compute"
  us_subnet1_id = module.vnet.us_subnet1_id
  eu_subnet1_id = module.vnet.eu_subnet1_id
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
  us_subnet1_id = module.vnet.us_subnet1_id
  eu_subnet1_id = module.vnet.eu_subnet1_id
  us_rg_name    = azurerm_resource_group.proj1_westus.name
  us_rg_loc     = azurerm_resource_group.proj1_westus.location
  eu_rg_name    = azurerm_resource_group.proj1_westeuro.name
  eu_rg_loc     = azurerm_resource_group.proj1_westeuro.location  
  lnx_vm_nics = module.compute.lnx_vm_nics
}