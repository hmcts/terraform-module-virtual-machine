locals {
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
  identity                 = var.systemassigned_identity == true || length(var.userassigned_identity_ids) > 0 ? { identity = { type = (var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : !var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"), identity_ids = var.userassigned_identity_ids } } : {}

  xdr_tags = join(",", flatten([
    "hmcts",
    "server",
    "crimeportal",
    "heritage",
    [var.env == "production" ? "production" : "nonprod"],
    [for key, value in var.tags : "${key}=${value}"]
  ]))
}