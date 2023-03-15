resource "azurerm_linux_virtual_machine" "lnx_vms" {
  for_each              = var.vm_names
  name                  = "${var.prefix}-${each.key}"
  location              = startswith(each.key, "r1") ? var.us_rg_loc : startswith(each.key, "r2") ? var.eu_rg_loc : ""
  resource_group_name   = startswith(each.key, "r1") ? var.us_rg_name : startswith(each.key, "r2") ? var.eu_rg_name : ""
  network_interface_ids = [azurerm_network_interface.vm_nics[each.key].id]
  size                  = "Standard_B2s"
  availability_set_id = startswith(each.key, "r1") ? azurerm_availability_set.lnx_vm_avset[0].id : startswith(each.key, "r2") ? azurerm_availability_set.lnx_vm_avset[1].id : ""
  custom_data = base64encode(templatefile(".\\server_setup.tftpl",
    { host = "${var.prefix}-${each.key}",
  region = startswith(each.key, "r1") ? var.us_rg_loc : startswith(each.key, "r2") ? var.eu_rg_loc : "" }))

  os_disk {
    name                 = "${each.key}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = lookup(var.lnx_vm_config, "publisher")
    offer     = lookup(var.lnx_vm_config, "offer")
    sku       = lookup(var.lnx_vm_config, "sku")
    version   = lookup(var.lnx_vm_config, "version")
  }

  computer_name                   = "${var.prefix}-${each.key}"
  admin_username                  = "kbolton3"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "kbolton3"
    public_key = file(".\\key-clo800.pub")
  }
}

resource "azurerm_windows_virtual_machine" "client_vms" {
  for_each              = var.client_names
  name                  = each.key
  location              = endswith(each.key, "r1") ? var.us_rg_loc : endswith(each.key, "r2") ? var.eu_rg_loc : ""
  resource_group_name   = endswith(each.key, "r1") ? var.us_rg_name : endswith(each.key, "r2") ? var.eu_rg_name : ""
  size                  = "Standard_B2s"
  admin_username        = "kbolton3"
  admin_password        = var.client_vm_pwd
  network_interface_ids = [azurerm_network_interface.client_nics[each.key].id]
  computer_name         = replace(each.key, "_", "-")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.client_vm_config, "publisher")
    offer     = lookup(var.client_vm_config, "offer")
    sku       = lookup(var.client_vm_config, "sku")
    version   = lookup(var.client_vm_config, "version")
  }
}