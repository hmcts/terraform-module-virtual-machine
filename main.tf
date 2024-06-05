locals {
  # see https://github.com/MicrosoftDocs/azure-docs/issues/91067#issuecomment-1089911200
  # Windows Server has a 15 char computer name limit
  # The portal truncates the name to 15 chars, but the API does not do this automatically
  # Also make sure that the name is valid by removing any invalid characters after truncation
  computer_name_calculated = replace(substr(var.vm_name, 0, 15), "/-$/", "")
  computer_name            = var.computer_name != null ? var.computer_name : local.computer_name_calculated

  # https://learn.microsoft.com/en-gb/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images
  # TODO switch to strcontains in tf 1.5.x
  automatic_by_platform_supported = can(regex("^2022-datacenter.*", var.vm_sku))
  patch_mode                      = "AutomaticByPlatform"
}

resource "azurerm_windows_virtual_machine" "winvm" {
  count               = lower(var.vm_type) == "windows" ? 1 : 0
  name                = var.vm_name
  computer_name       = local.computer_name
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
    disk_size_gb           = var.os_disk_size_gb
  }

  patch_mode = local.patch_mode

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

  dynamic "identity" {
    for_each = local.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags       = var.tags
  depends_on = [azurerm_disk_encryption_set.disk_enc_set, azurerm_key_vault_access_policy.disk_policy]
}

resource "azurerm_linux_virtual_machine" "linvm" {
  count                           = lower(var.vm_type) == "linux" ? 1 : 0
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
    disk_size_gb           = var.os_disk_size_gb
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

  dynamic "identity" {
    for_each = local.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags       = var.tags
  depends_on = [azurerm_disk_encryption_set.disk_enc_set]
}
