output "vm_id" {
  value = var.vm_type == "windows" ? azurerm_windows_virtual_machine.winvm[0].id : var.vm_type == "linux" ? azurerm_linux_virtual_machine.linvm[0].id : null
}

output "system_assigned_identity_oid" {
  value = var.vm_type == "windows" && var.systemassigned_identity == true ? azurerm_windows_virtual_machine.winvm[0].identity[0].principal_id : var.vm_type == "linux" && var.systemassigned_identity == true ? azurerm_linux_virtual_machine.linvm[0].identity[0].principal_id : null
}

output "nic_id" {
  value = azurerm_network_interface.vm_nic.id
}

output "vm_private_ip_address" {
  value = azurerm_network_interface.vm_nic.private_ip_address
}

output "xdr_tags" {
  value = var.run_command ? module.vm-bootstrap[0].XDR_TAGS : null
}
