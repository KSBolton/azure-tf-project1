resource "tls_private_key" "vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "vm_pub_key" {
  for_each = var.vm_names
  name = "${each.key}_vm_pub_key"
  location              = startswith(each.key, "r1") ? var.us_rg_loc : startswith(each.key, "r2") ? var.eu_rg_loc : ""
  resource_group_name   = startswith(each.key, "r1") ? var.us_rg_name : startswith(each.key, "r2") ? var.eu_rg_name : ""
  public_key = tls_private_key.vm_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.vm_key.private_key_pem}' > aws_keys_pairs.pem"
  }
}