output "linux_pvt_key" {
  value = module.vms.private_key_openssh
  sensitive = true
}

output "client_pwd" {
  value = module.keyvault.client_vm_pwd
  sensitive = true
}