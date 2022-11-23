module "diskencrypt" {
  count                = var.encrypt_ADE ? 1 : 0
  source               = "https://github.com/Azure/terraform-azurerm-diskencrypt.git"
  resource_group_name  = var.vm_resource_group
  location             = var.vm_location
  vm_name              = var.vm_name
  key_vault_name       = var.kv_name
  encryption_algorithm = "RSA-OAEP"
  encryption_key_url   = azurerm_key_vault_key.disk_enc_key.id

  tags = var.tags
}