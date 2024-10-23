locals {
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
  identity                 = var.systemassigned_identity == true || length(var.userassigned_identity_ids) > 0 ? { identity = { type = (var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : !var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"), identity_ids = var.userassigned_identity_ids } } : {}
  vm_password_required     = var.vm_admin_ssh_key == null && var.disable_password_authentication == false
  vm_ssh_key_required      = var.vm_admin_password == null && var.disable_password_authentication == true
  admin_ssh_key            = var.vm_admin_ssh_key != null && var.disable_password_authentication == true ? { dummy_create = true } : {}
}
