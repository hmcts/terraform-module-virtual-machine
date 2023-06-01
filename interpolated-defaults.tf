locals {
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
  identity_type            = var.systemassigned_identity && var.userassigned_identity_ids != null && length(var.userassigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : !var.systemassigned_identity && var.userassigned_identity_ids != null && length(var.userassigned_identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
  identity                 = var.systemassigned_identity == true || var.userassigned_identity_ids != null || length(var.userassigned_identity_ids) > 0 ? [{ type = local.identity_type, identity_ids = var.userassigned_identity_ids }] : []
}
