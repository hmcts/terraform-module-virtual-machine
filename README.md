# terraform-module-virtual-machine
This module lets you deploy either a Windows VM or Linux VM and optionally allows you to Encrypt Disks using Customer Managed Key (CMK).

## Example
```terraform
module "virtual_machine" {
  source               = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=master"

  vm_type              = "linux"
  vm_name              = "example-vm"
  vm_resource_group    = "example-resource-group"
  vm_admin_password    = "example-super-secure-password" # ideally from a secret store
  vm_subnet_id         = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/xxxx/subnets/xxx"
  vm_publisher_name    = "canonical"
  vm_offer             = "0001-com-ubuntu-server-jammy"
  vm_sku               = "22_04-lts-gen2"
  vm_size              = "Standard_D2ds_v5"
  vm_version           = "latest"
  vm_availabilty_zones = "1"
  tags                 = var.common_tags
}
```
An example can be found [here](https://github.com/hmcts/terraform-module-virtual-machine/tree/master/example).

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm-bootstrap"></a> [vm-bootstrap](#module\_vm-bootstrap) | git::https://github.com/hmcts/terraform-module-vm-bootstrap.git | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_disk_encryption_set.disk_enc_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_access_policy.disk_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.disk_enc_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_linux_virtual_machine.linvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.managed_disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.winvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_key_vault.enc_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerated_networking_enabled"></a> [accelerated\_networking\_enabled](#input\_accelerated\_networking\_enabled) | Enable accelerated networks on the NIC for the virtual machine. | `bool` | `false` | no |
| <a name="input_additional_script_name"></a> [additional\_script\_name](#input\_additional\_script\_name) | The path to a script to run against the virtual machine. | `string` | `null` | no |
| <a name="input_additional_script_uri"></a> [additional\_script\_uri](#input\_additional\_script\_uri) | URI of a publically accessible script to run against the virtual machine. | `string` | `null` | no |
| <a name="input_aum_schedule_enable"></a> [aum\_schedule\_enable](#input\_aum\_schedule\_enable) | Specifies whether to skip platform scheduled patching when a user schedule is associated with the VM. Defaults to false. HMCTS use this to set AUM as Customer Managed Schedules | `bool` | `true` | no |
| <a name="input_availability_set_name"></a> [availability\_set\_name](#input\_availability\_set\_name) | Name of the availability\_set | `string` | `""` | no |
| <a name="input_boot_diagnostics_enabled"></a> [boot\_diagnostics\_enabled](#input\_boot\_diagnostics\_enabled) | Whether to enable boot diagnostics. | `bool` | `true` | no |
| <a name="input_boot_storage_uri"></a> [boot\_storage\_uri](#input\_boot\_storage\_uri) | The URI of the storage to use for boot diagnostics. | `string` | `null` | no |
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | Override the computer name of the VM. If not set, the computer name will be the same as the VM name truncated to 15 characters (Windows only). | `any` | `null` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | Custom data to pass to the virtual machine. | `string` | `null` | no |
| <a name="input_custom_image_id"></a> [custom\_image\_id](#input\_custom\_image\_id) | The ID of a custom image to use. | `string` | `""` | no |
| <a name="input_custom_script_extension_name"></a> [custom\_script\_extension\_name](#input\_custom\_script\_extension\_name) | Overwrite custom script extension name label in bootstrap module. | `string` | `"HMCTSVMBootstrap"` | no |
| <a name="input_disable_password_authentication"></a> [disable\_password\_authentication](#input\_disable\_password\_authentication) | Disable password authentication on the virtual machine. | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS servers to use, will override DNS servers set at the VNET level | `list(string)` | `null` | no |
| <a name="input_dynatrace_hostgroup"></a> [dynatrace\_hostgroup](#input\_dynatrace\_hostgroup) | The hostgroup to place the virtual machine in within DynaTrace | `string` | `null` | no |
| <a name="input_dynatrace_server"></a> [dynatrace\_server](#input\_dynatrace\_server) | The Dynatrace ActiveGate server URL. | `string` | `null` | no |
| <a name="input_dynatrace_tenant_id"></a> [dynatrace\_tenant\_id](#input\_dynatrace\_tenant\_id) | The Dynatrace tenant ID. | `string` | `""` | no |
| <a name="input_dynatrace_token"></a> [dynatrace\_token](#input\_dynatrace\_token) | The token to use when communicating with the Dynatrace ActiveGate. | `string` | `""` | no |
| <a name="input_enable_availability_set"></a> [enable\_availability\_set](#input\_enable\_availability\_set) | Enable availability set or not, default is false | `bool` | `false` | no |
| <a name="input_encrypt_CMK"></a> [encrypt\_CMK](#input\_encrypt\_CMK) | Encrypt the disks with a customer-managed key. | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment name | `string` | n/a | yes |
| <a name="input_install_azure_monitor"></a> [install\_azure\_monitor](#input\_install\_azure\_monitor) | Install Azure Monitor Agent. | `bool` | `true` | no |
| <a name="input_install_docker"></a> [install\_docker](#input\_install\_docker) | Install Docker and Docker Compose - Ubuntu only 20.04+ | `bool` | `false` | no |
| <a name="input_install_dynatrace_oneagent"></a> [install\_dynatrace\_oneagent](#input\_install\_dynatrace\_oneagent) | Install dynatrace OneAgent. | `bool` | `true` | no |
| <a name="input_install_splunk_uf"></a> [install\_splunk\_uf](#input\_install\_splunk\_uf) | Install splunk uniforwarder on the virtual machine. | `bool` | `true` | no |
| <a name="input_ipconfig_name"></a> [ipconfig\_name](#input\_ipconfig\_name) | The name of the IPConfig to asssoicate with the NIC. | `string` | `null` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name ofthe KeyVault used to store the customer-managed key. | `string` | `null` | no |
| <a name="input_kv_rg_name"></a> [kv\_rg\_name](#input\_kv\_rg\_name) | The name of the resource group, containing the KeyVault used to store the customer-managed key. | `string` | `null` | no |
| <a name="input_managed_disks"></a> [managed\_disks](#input\_managed\_disks) | A map of managed disks to create & attach to the virtual machine. | <pre>map(<br/>    object(<br/>      {<br/>        name                     = string,<br/>        location                 = string,<br/>        resource_group_name      = string,<br/>        storage_account_type     = string,<br/>        disk_create_option       = string,<br/>        disk_size_gb             = string,<br/>        disk_tier                = string,<br/>        disk_zone                = string,<br/>        source_resource_id       = string,<br/>        storage_account_id       = string,<br/>        hyper_v_generation       = string,<br/>        os_type                  = string,<br/>        disk_lun                 = string,<br/>        disk_caching             = string,<br/>        attachment_create_option = string<br/>      }<br/>    )<br/>  )</pre> | `{}` | no |
| <a name="input_nessus_groups"></a> [nessus\_groups](#input\_nessus\_groups) | The Tenable Nessus group name. | `string` | `"Platform-Operation-Bastions"` | no |
| <a name="input_nessus_install"></a> [nessus\_install](#input\_nessus\_install) | Install Tenable Nessus on the virtual machine. | `bool` | `true` | no |
| <a name="input_nessus_key"></a> [nessus\_key](#input\_nessus\_key) | The key to use when communicating with Tenable Nessus. | `string` | `null` | no |
| <a name="input_nessus_server"></a> [nessus\_server](#input\_nessus\_server) | The Tenable Nessus server URL. | `string` | `""` | no |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | The name of the NIC to create & associate with the virtual machine. | `string` | `null` | no |
| <a name="input_os_disk_size_gb"></a> [os\_disk\_size\_gb](#input\_os\_disk\_size\_gb) | The operating system disk size in GB. | `string` | `"128"` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The operating system disk storack account type. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | The operating system disk type. | `string` | `"ReadWrite"` | no |
| <a name="input_privateip_allocation"></a> [privateip\_allocation](#input\_privateip\_allocation) | The type of private IP allocation, either Static or Dynamic. | `string` | `"Static"` | no |
| <a name="input_provision_vm_agent"></a> [provision\_vm\_agent](#input\_provision\_vm\_agent) | If patch\_assessment\_mode AutomaticByPlatform then the provision\_vm\_agent field must be set to true. | `bool` | `true` | no |
| <a name="input_rc_os_sku"></a> [rc\_os\_sku](#input\_rc\_os\_sku) | The SKU of run command to use. | `string` | `null` | no |
| <a name="input_rc_script_file"></a> [rc\_script\_file](#input\_rc\_script\_file) | The path to the script file to run against the virtual machine. | `string` | `null` | no |
| <a name="input_run_cis"></a> [run\_cis](#input\_run\_cis) | Install CIS hardening using run command script? | `bool` | `false` | no |
| <a name="input_run_command"></a> [run\_command](#input\_run\_command) | Run a custom command/script against the virtual machine using a run command extension. | `bool` | `false` | no |
| <a name="input_run_command_sa_key"></a> [run\_command\_sa\_key](#input\_run\_command\_sa\_key) | SA key for the run command | `string` | `""` | no |
| <a name="input_run_xdr_agent"></a> [run\_xdr\_agent](#input\_run\_xdr\_agent) | Install XDR agents using run command script? | `bool` | `false` | no |
| <a name="input_run_xdr_collector"></a> [run\_xdr\_collector](#input\_run\_xdr\_collector) | Install XDR collectors using run command script? | `bool` | `false` | no |
| <a name="input_splunk_group"></a> [splunk\_group](#input\_splunk\_group) | Splunk universal forwarder global target group. | `string` | `"hmcts_forwarders"` | no |
| <a name="input_splunk_pass4symmkey"></a> [splunk\_pass4symmkey](#input\_splunk\_pass4symmkey) | Splunk universal forwarder communication security key. | `string` | `null` | no |
| <a name="input_splunk_password"></a> [splunk\_password](#input\_splunk\_password) | Splunk universal forwarder local admin password. | `string` | `null` | no |
| <a name="input_splunk_username"></a> [splunk\_username](#input\_splunk\_username) | Splunk universal forwarder local admin username. | `string` | `null` | no |
| <a name="input_systemassigned_identity"></a> [systemassigned\_identity](#input\_systemassigned\_identity) | Enable System Assigned managed identity for the virtual machine. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the virtual machine and associated resources. | `map(string)` | n/a | yes |
| <a name="input_userassigned_identity_ids"></a> [userassigned\_identity\_ids](#input\_userassigned\_identity\_ids) | List of User Manager Identity IDs to associate with the virtual machine. | `list(string)` | `[]` | no |
| <a name="input_vm_admin_name"></a> [vm\_admin\_name](#input\_vm\_admin\_name) | The name of the admin user. | `string` | `"VMAdmin"` | no |
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | The Admin password for the virtual machine. This or vm\_admin\_ssh\_key must be set. | `string` | `null` | no |
| <a name="input_vm_admin_ssh_key"></a> [vm\_admin\_ssh\_key](#input\_vm\_admin\_ssh\_key) | The SSH public key to use for the admin user. This or vm\_admin\_password must be set. | `string` | `null` | no |
| <a name="input_vm_availabilty_zones"></a> [vm\_availabilty\_zones](#input\_vm\_availabilty\_zones) | The availability zones to deploy the VM in | `string` | n/a | yes |
| <a name="input_vm_location"></a> [vm\_location](#input\_vm\_location) | The Azure Region to deploy the virtual machine in. | `string` | `"uksouth"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the Virtual Machine | `string` | n/a | yes |
| <a name="input_vm_offer"></a> [vm\_offer](#input\_vm\_offer) | The offer of the marketplace image to use. | `string` | n/a | yes |
| <a name="input_vm_patch_assessment_mode"></a> [vm\_patch\_assessment\_mode](#input\_vm\_patch\_assessment\_mode) | Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are AutomaticByPlatform or ImageDefault. Defaults to ImageDefault | `string` | `"AutomaticByPlatform"` | no |
| <a name="input_vm_patch_mode"></a> [vm\_patch\_mode](#input\_vm\_patch\_mode) | Used to set Azure Update Manager configuration. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS. | `string` | `"AutomaticByPlatform"` | no |
| <a name="input_vm_private_ip"></a> [vm\_private\_ip](#input\_vm\_private\_ip) | The private IP to assign to the virtual machine. | `string` | `null` | no |
| <a name="input_vm_public_ip_address"></a> [vm\_public\_ip\_address](#input\_vm\_public\_ip\_address) | The public IP address to assign to the virtual machine. | `string` | `null` | no |
| <a name="input_vm_publisher_name"></a> [vm\_publisher\_name](#input\_vm\_publisher\_name) | The publiser of the marketplace image to use. | `string` | n/a | yes |
| <a name="input_vm_resource_group"></a> [vm\_resource\_group](#input\_vm\_resource\_group) | The name of the resource group to deploy the virtual machine in. | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The virtual machine Size. | `string` | n/a | yes |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | The SKU of the image to use. | `string` | n/a | yes |
| <a name="input_vm_subnet_id"></a> [vm\_subnet\_id](#input\_vm\_subnet\_id) | The Subnet ID to connect the virtual machine to. | `string` | n/a | yes |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | The type of the vm, either 'windows' or 'linux' | `string` | n/a | yes |
| <a name="input_vm_version"></a> [vm\_version](#input\_vm\_version) | The version of the image to use. | `string` | n/a | yes |
| <a name="input_xdr_tags"></a> [xdr\_tags](#input\_xdr\_tags) | XDR specific Tags | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nic_id"></a> [nic\_id](#output\_nic\_id) | n/a |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | n/a |
| <a name="output_vm_private_ip_address"></a> [vm\_private\_ip\_address](#output\_vm\_private\_ip\_address) | n/a |
| <a name="output_xdr_tags"></a> [xdr\_tags](#output\_xdr\_tags) | n/a |
<!-- END_TF_DOCS -->
