resource "azurerm_managed_disk" "managed_disks" {
  for_each             = var.managed_disks
  name                 = each.value.name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type

  # Valid options are Import, Empty, Copy, FromImage, Restore
  create_option = each.value.disk_create_option

  disk_size_gb           = each.value.disk_size_gb
  tier                   = each.value.disk_tier
  zone                   = each.value.disk_zone
  source_resource_id     = each.value.source_resource_id
  storage_account_id     = each.value.storage_account_id
  hyper_v_generation     = each.value.hyper_v_generation
  os_type                = each.value.os_type
  disk_encryption_set_id = var.encrypt_disks ? azurerm_disk_encryption_set.disk_enc_set[0].id : null

  tags = var.tags

  depends_on = [
    azurerm_linux_virtual_machine.linvm,
    azurerm_windows_virtual_machine.winvm
  ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachments" {
  for_each           = var.managed_disks
  managed_disk_id    = azurerm_managed_disk.managed_disks[each.key].id
  virtual_machine_id = var.vm_type == "linux" ? azurerm_linux_virtual_machine.linvm[0].id : azurerm_windows_virtual_machine.winvm[0].id
  lun                = each.value.disk_lun
  caching            = each.value.disk_caching

  # Valid options are Attach Empty. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment#create_option
  create_option = each.value.attachment_create_option

  depends_on = [
    azurerm_linux_virtual_machine.linvm,
    azurerm_windows_virtual_machine.winvm
  ]
}