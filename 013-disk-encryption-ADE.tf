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

  depends_on = [azurerm_windows_virtual_machine.winvm, azurerm_linux_virtual_machine.linvm, azurerm_virtual_machine_data_disk_attachment.data_disk_attachments]
}

# resource "azurerm_virtual_machine_extension" "vmextensionlinux" {
#   count                      = lower(var.vm_type) == "linux" && var.encrypt_ADE ? 1 : 0
#   name                       = "azure-disk-encrypt-${random_string.password.result}"
#   location                   = "${data.azurerm_resource_group.test.location}"
#   resource_group_name        = "${data.azurerm_resource_group.test.name}"
#   virtual_machine_name       = "${var.vm_name}"
#   publisher                  = "Microsoft.Azure.Security"
#   type                       = "AzureDiskEncryptionForLinux"
#   type_handler_version       = "${var.type_handler_version == "" ? "1.1" : var.type_handler_version}"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#         "EncryptionOperation": "${var.encrypt_operation}",
#         "KeyVaultURL": "${data.azurerm_key_vault.keyvault.vault_uri}",
#         "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
#         "KeyEncryptionKeyURL": "${var.encryption_key_url}",
#         "KekVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
#         "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
#         "VolumeType": "${var.volume_type}"
#     }
# SETTINGS

#   tags = "${var.tags}"
# }