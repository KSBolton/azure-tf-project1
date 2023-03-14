output "client_vm_pwd" {
  value = azurerm_key_vault_secret.client_vm_pwd.value
}