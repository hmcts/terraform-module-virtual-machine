locals {
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
}
