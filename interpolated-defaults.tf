locals {
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
  identity                 = var.systemassigned_identity == true || length(var.userassigned_identity_ids) > 0 ? { identity = { type = (var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : !var.systemassigned_identity && length(var.userassigned_identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"), identity_ids = var.userassigned_identity_ids } } : {}
}

data "null_data_source" "tag_defaults" {
  inputs = {
    Project_Name         = var.tag_project_name
    Environment          = var.tag_environment
    Cost_Center          = var.tag_cost_center
    Service              = var.tag_service
    App_Operations_Owner = var.tag_app_operations_owner
    System_Owner         = var.tag_system_owner
    Budget_Owner         = var.tag_budget_owner
    Created_By           = "Terraform"
    BuiltFrom            = "hmcts/martha-infra"
    BusinessArea         = "Cross-Cutting"
    Application          = "martha"
  }
}