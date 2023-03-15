resource "azurerm_resource_group" "kv_rg" {
  name = "keyvault-rg"
  location = "Canada Central"
}

resource "random_id" "kv_name" {
  byte_length = 6
  prefix = "kv"
}

data "azurerm_client_config" "my_az_config" {}

resource "azurerm_key_vault" "proj1_kv" {
  depends_on = [
    azurerm_resource_group.kv_rg
  ]
  name = random_id.kv_name.hex
  location = azurerm_resource_group.kv_rg.location
  resource_group_name = azurerm_resource_group.kv_rg.name
  enabled_for_disk_encryption = true
  tenant_id = data.azurerm_client_config.my_az_config.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.my_az_config.tenant_id
    object_id = data.azurerm_client_config.my_az_config.object_id

    key_permissions = ["get",]

    secret_permissions = ["get", "backup", "delete", "list", "purge", "recover", "restore", "set",]

    storage_permissions = ["get",]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.my_az_config.tenant_id
    object_id = local.odl_object_id

    key_permissions = ["get",]

    secret_permissions = ["get", "backup", "delete", "list", "purge", "recover", "restore", "set",]

    storage_permissions = ["get",]
  }
}

resource "random_password" "client_vm_pwd" {
  length = 20
  special = true
}

resource "azurerm_key_vault_secret" "client_vm_pwd" {
  name = "client-vm-password"
  value = random_password.client_vm_pwd.result
  key_vault_id = azurerm_key_vault.proj1_kv.id
  depends_on = [
    azurerm_key_vault.proj1_kv
  ]
}