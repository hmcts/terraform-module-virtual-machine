resource "azurerm_windows_virtual_machine" "winvm" {
  count               = var.vm_type == "windows" ? 1 : 0
  name                = var.vm_name
  resource_group_name = var.vm_resource_group
  location            = var.vm_location
  size                = var.vm_size
  admin_username      = var.vm_admin_name
  admin_password      = var.vm_admin_password
  zone                = var.vm_availabilty_zones
  custom_data         = var.custom_data
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching                = var.os_disk_type
    storage_account_type   = var.os_disk_storage_account_type
    disk_encryption_set_id = var.encrypt_CMK ? azurerm_disk_encryption_set.disk_enc_set[0].id : null
  }

  identity {
    count        = var.identity != null ? 1 : 0
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.identity
  }

  source_image_reference {

    publisher = var.vm_publisher_name
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version

  }

  dynamic "boot_diagnostics" {
    for_each = local.dynamic_boot_diagnostics
    content {
      storage_account_uri = var.boot_storage_uri
    }
  }

  tags       = var.tags
  depends_on = [azurerm_disk_encryption_set.disk_enc_set, azurerm_key_vault_access_policy.disk_policy]
  lifecycle {
    precondition {
      condition     = (var.encrypt_CMK && !var.encrypt_ADE) || (!var.encrypt_CMK && var.encrypt_ADE) || (!var.encrypt_CMK && !var.encrypt_ADE)
      error_message = "You can either have Customer Managed Key Encryption or Azure Disk Encryption, you can not encrypt with both"
    }
  }
}

resource "azurerm_linux_virtual_machine" "linvm" {
  count                           = var.vm_type == "linux" ? 1 : 0
  name                            = var.vm_name
  resource_group_name             = var.vm_resource_group
  location                        = var.vm_location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_name
  admin_password                  = var.vm_admin_password
  zone                            = var.vm_availabilty_zones
  custom_data                     = var.custom_data
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]


  os_disk {
    caching                = var.os_disk_type
    storage_account_type   = var.os_disk_storage_account_type
    disk_encryption_set_id = var.encrypt_CMK ? azurerm_disk_encryption_set.disk_enc_set[0].id : null
  }

  identity {
    count        = var.identity != null ? 1 : 0
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.identity
  }

  source_image_reference {

    publisher = var.vm_publisher_name
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  dynamic "boot_diagnostics" {
    for_each = local.dynamic_boot_diagnostics
    content {

      storage_account_uri = var.boot_storage_uri
    }
  }

  tags       = var.tags
  depends_on = [azurerm_disk_encryption_set.disk_enc_set]
}

# resource "azurerm_marketplace_agreement" "this" {
#   publisher = var.vm_publisher_name
#   offer     = var.vm_offer
#   plan      = var.marketplace_sku

#   depends_on = [
#     azurerm_linux_virtual_machine.linvm,
#     azurerm_windows_virtual_machine.winvm
#   ]
# }