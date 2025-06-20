
module "vm-bootstrap" {
  providers = {
    azurerm     = azurerm
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
    azurerm.dcr = azurerm.dcr
  }

  count  = var.remove_splunk_uf == true || var.install_splunk_uf == true || var.nessus_install == true || var.run_command == true || var.install_azure_monitor == true ? 1 : 0
  source = "git::https://github.com/hmcts/terraform-module-vm-bootstrap.git?ref=master"

  virtual_machine_type       = "vm"
  virtual_machine_id         = lower(var.vm_type) == "linux" ? azurerm_linux_virtual_machine.linvm[0].id : azurerm_windows_virtual_machine.winvm[0].id
  env                        = var.env
  splunk_username            = var.splunk_username
  splunk_password            = var.splunk_password
  splunk_pass4symmkey        = var.splunk_pass4symmkey
  splunk_group               = var.splunk_group
  os_type                    = lower(var.vm_type) == "linux" ? "Linux" : "Windows"
  nessus_server              = var.nessus_server
  nessus_key                 = var.nessus_key
  nessus_groups              = var.nessus_groups
  install_dynatrace_oneagent = var.install_dynatrace_oneagent
  install_azure_monitor      = var.install_azure_monitor
  install_nessus_agent       = var.nessus_install
  install_docker             = var.install_docker
  install_splunk_uf          = var.install_splunk_uf
  remove_splunk_uf           = var.remove_splunk_uf
  enable_winrm               = var.enable_winrm
  enable_port80              = var.enable_port80
  enable_fileshare           = var.enable_fileshare
  mount_sa                   = var.mount_sa
  mount_fs                   = var.mount_fs

  dynatrace_hostgroup = var.dynatrace_hostgroup
  dynatrace_server    = var.dynatrace_server
  dynatrace_tenant_id = var.dynatrace_tenant_id
  dynatrace_token     = var.dynatrace_token

  run_command        = var.run_command
  rc_script_file     = var.rc_script_file
  rc_os_sku          = var.rc_os_sku
  run_command_sa_key = var.run_command_sa_key
  run_xdr_collector  = var.run_xdr_collector
  run_xdr_agent      = var.run_xdr_agent
  run_cis            = var.run_cis
  xdr_tags           = var.xdr_tags

  additional_script_uri        = var.additional_script_uri
  additional_script_name       = var.additional_script_name
  custom_script_extension_name = var.custom_script_extension_name

  soc_vault_rg   = var.soc_vault_rg
  soc_vault_name = var.soc_vault_name

  common_tags = var.tags
}

#--------------------------------------------------------------
# AADSSHLoginForLinux for Linux extension
#--------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "entra" {
  count                      = var.deploy_entra_extension && lower(var.vm_type) == "linux" ? 1 : 0
  name                       = "AADSSHLoginForLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.linvm[0].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = var.aad_type_handler_version
  auto_upgrade_minor_version = true
}

resource "azurerm_role_assignment" "admin-user" {
  for_each             = var.deploy_entra_extension && lower(var.vm_type) == "linux" ? { for key, value in var.rbac_config : key => value } : {}
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
