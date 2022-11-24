resource "random_string" "password" {
  length  = 4
  special = false
}


resource "azurerm_virtual_machine_extension" "vmextension" {
  count                      = var.encrypt_ADE ? 1 : 0
  name                       = "azure-disk-encrypt-${random_string.password.result}"
  virtual_machine_id         = lower(var.vm_type) == "windows" ? azurerm_windows_virtual_machine.winvm[0].id : azurerm_linux_virtual_machine.linvm[0].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = lower(var.vm_type) == "windows" ? "AzureDiskEncryption" : "AzureDiskEncryptionForLinux"
  type_handler_version       = lower(var.vm_type) == "windows" ? "2.2" : "1.1"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    "EncryptionOperation"    = "EnableEncryption"
    "KeyEncryptionAlgorithm" = "RSA-OAEP"
    "KeyVaultURL"            = data.azurerm_key_vault.enc_kv[0].vault_uri
    "KeyVaultResourceId"     = data.azurerm_key_vault.enc_kv[0].id
    "KeyEncryptionKeyURL"    = azurerm_key_vault_key.disk_enc_key[0].id
    "KekVaultResourceId"     = data.azurerm_key_vault.enc_kv[0].id
    "VolumeType"             = "All"
  })


  tags = var.tags

  depends_on = [azurerm_windows_virtual_machine.winvm, azurerm_linux_virtual_machine.linvm, azurerm_virtual_machine_data_disk_attachment.data_disk_attachments,azurerm_key_vault_key.disk_enc_key]
}
