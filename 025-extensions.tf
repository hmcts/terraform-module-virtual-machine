
module "vm-bootstrap" {
  count  = var.install_splunk_uf == true || var.nessus_install == true ? 1 : 0
  source = "git::https://github.com/hmcts/terraform-module-vm-bootstrap.git?ref=master"

  virtual_machine_type       = "vm"
  virtual_machine_id         = var.vm_type == "linux" ? azurerm_linux_virtual_machine.linvm[0].id : azurerm_windows_virtual_machine.winvm[0].id
  splunk_username            = var.splunk_username
  splunk_password            = var.splunk_password
  splunk_pass4symmkey        = var.splunk_pass4symmkey
  splunk_group               = var.splunk_group
  os_type                    = var.vm_type == "linux" ? "Linux" : "Windows"
  nessus_server              = var.nessus_server
  nessus_key                 = var.nessus_key
  nessus_groups              = var.nessus_groups
  install_dynatrace_oneagent = true
  install_azure_monitor      = true

  dynatrace_hostgroup = var.dynatrace_hostgroup
  dynatrace_server    = var.dynatrace_server
  dynatrace_tenant_id = var.dynatrace_tenant_id
  dynatrace_token     = var.dynatrace_token

  common_tags = var.tags
}
