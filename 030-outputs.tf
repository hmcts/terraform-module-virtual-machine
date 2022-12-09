output "vm_id" {
  value = var.vm_type == "windows" ? azurerm_windows_virtual_machine.winvm.id : var.vm_type == "linux" ? azurerm_linux_virtual_machine.linvm.id : null
}
