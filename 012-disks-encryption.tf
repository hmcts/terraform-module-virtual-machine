
data "azurerm_key_vault" "enc_kv" {
  count               = var.encrypt_disks ? 1 : 0
  name                = var.kv_name
  resource_group_name = var.kv_rg_name
}

resource "azurerm_key_vault_key" "disk_enc_key" {
  count        = var.encrypt_disks ? 1 : 0
  name         = "disk-encrypt-${var.kv_name}"
  key_vault_id = data.azurerm_key_vault.enc_kv[0].id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "disk_enc_set" {
  count               = var.create_disk_set ? 1 : 0
  name                = "disk_enc_set"
  resource_group_name = var.vm_resource_group
  location            = var.vm_location
  key_vault_key_id    = azurerm_key_vault_key.disk_enc_key[0].id
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "disk_policy" {
  count        = var.encrypt_disks ? 1 : 0
  key_vault_id = data.azurerm_key_vault.enc_kv[0].id

  tenant_id = azurerm_disk_encryption_set.disk_enc_set[0].identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.disk_enc_set[0].identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}
