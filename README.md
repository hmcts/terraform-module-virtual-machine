# terraform-module-virtual-machine
This is VM module let you deploy either Windows VM or Linux VM and also allow you to Disk Encryption either using Customer Managed Key (CMK) or Azure Disk Encryption (ADE).

#### Note: Please make sure if you are encrypting disk using ADE encryption on windows device, you have to make sure that your disks are mounted and formatted before installing extension, please use this powershell script here ####
```shell
https://github.com/hmcts/CIS-harderning/blob/master/windows-disk-mounting.ps1 
```

## Example
```terraform
module "virtual-machine" {
  source               = "git::https://github.com/hmcts/terraform-module-virtual-machine.git?ref=master"

  vm_type              = "linux"
  vm_name              = "example-vm"
  vm_resource_group    = "example-resource-group"
  vm_admin_password    = "example-super-secure-password" # ideally from a secret store
  vm_subnet_id         = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/xxxx/subnets/xxx"
  vm_publisher_name    = "canonical"
  vm_offer             = "0001-com-ubuntu-server-jammy"
  vm_sku               = "22_04-lts-gen2"
  vm_size              = "D2ds_v5"
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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm-bootstrap"></a> [vm-bootstrap](#module\_vm-bootstrap) | git::https://github.com/hmcts/terraform-module-vm-bootstrap.git | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_disk_encryption_set.disk_enc_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_access_policy.disk_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.disk_enc_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_linux_virtual_machine.linvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.managed_disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.vm_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachments](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.vmextension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.winvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_string.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_key_vault.enc_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerated_networking_enabled"></a> [accelerated\_networking\_enabled](#input\_accelerated\_networking\_enabled) | Enable accelerated networks on the NIC for the virtual machine. | `bool` | `false` | no |
| <a name="input_additional_script_name"></a> [additional\_script\_name](#input\_additional\_script\_name) | The path to a script to run against the virtual machine. | `string` | `null` | no |
| <a name="input_additional_script_uri"></a> [additional\_script\_uri](#input\_additional\_script\_uri) | URI of a publically accessible script to run against the virtual machine. | `string` | `null` | no |
| <a name="input_boot_diagnostics_enabled"></a> [boot\_diagnostics\_enabled](#input\_boot\_diagnostics\_enabled) | Whether to enable boot diagnostics. | `bool` | `true` | no |
| <a name="input_boot_storage_uri"></a> [boot\_storage\_uri](#input\_boot\_storage\_uri) | The URI of the storage to use for boot diagnostics. | `string` | `null` | no |
| <a name="input_custom_data"></a> [custom\_data](#input\_custom\_data) | Custom data to pass to the virtual machine. | `string` | `null` | no |
| <a name="input_custom_image_id"></a> [custom\_image\_id](#input\_custom\_image\_id) | The ID of a custom image to use. | `string` | `""` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS servers to use, will override DNS servers set at the VNET level | `list(string)` | `null` | no |
| <a name="input_dynatrace_hostgroup"></a> [dynatrace\_hostgroup](#input\_dynatrace\_hostgroup) | The hostgroup to place the virtual machine in within DynaTrace | `string` | `null` | no |
| <a name="input_dynatrace_server"></a> [dynatrace\_server](#input\_dynatrace\_server) | The Dynatrace ActiveGate server URL. | `string` | `null` | no |
| <a name="input_dynatrace_tenant_id"></a> [dynatrace\_tenant\_id](#input\_dynatrace\_tenant\_id) | The Dynatrace tenant ID. | `string` | `null` | no |
| <a name="input_dynatrace_token"></a> [dynatrace\_token](#input\_dynatrace\_token) | The token to use when communicating with the Dynatrace ActiveGate. | `string` | `null` | no |
| <a name="input_encrypt_ADE"></a> [encrypt\_ADE](#input\_encrypt\_ADE) | Encrypt the disks using Azure Disk Encryption. | `bool` | `false` | no |
| <a name="input_encrypt_CMK"></a> [encrypt\_CMK](#input\_encrypt\_CMK) | Encrypt the disks with a customer-managed key. | `bool` | `false` | no |
| <a name="input_install_azure_monitor"></a> [install\_azure\_monitor](#input\_install\_azure\_monitor) | Install Azure Monitor on the virtual machine. | `bool` | `true` | no |
| <a name="input_install_dynatrace_oneagent"></a> [install\_dynatrace\_oneagent](#input\_install\_dynatrace\_oneagent) | Install dynatrace oneagent on the virtual machine. | `bool` | `true` | no |
| <a name="input_install_splunk_uf"></a> [install\_splunk\_uf](#input\_install\_splunk\_uf) | Insall splunk uniforwarder on the virtual machine. | `bool` | `false` | no |
| <a name="input_ipconfig_name"></a> [ipconfig\_name](#input\_ipconfig\_name) | The name of the IPConfig to asssoicate with the NIC. | `string` | `null` | no |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | The name ofthe KeyVault used to store the customer-managed key. | `string` | `null` | no |
| <a name="input_kv_rg_name"></a> [kv\_rg\_name](#input\_kv\_rg\_name) | The name of the resource group, containing the KeyVault used to store the customer-managed key. | `string` | `null` | no |
| <a name="input_managed_disks"></a> [managed\_disks](#input\_managed\_disks) | A map of managed disks to create & attach to the virtual machine. | <pre>map(<br>    object(<br>      {<br>        name                     = string,<br>        location                 = string,<br>        resource_group_name      = string,<br>        storage_account_type     = string,<br>        disk_create_option       = string,<br>        disk_size_gb             = string,<br>        disk_tier                = string,<br>        disk_zone                = string,<br>        source_resource_id       = string,<br>        storage_account_id       = string,<br>        hyper_v_generation       = string,<br>        os_type                  = string,<br>        disk_lun                 = string,<br>        disk_caching             = string,<br>        attachment_create_option = string<br>      }<br>    )<br>  )</pre> | <pre>{<br>  "datadisk1": {<br>    "attachment_create_option": "Attach",<br>    "disk_caching": "ReadWrite",<br>    "disk_create_option": "Empty",<br>    "disk_lun": "10",<br>    "disk_size_gb": "128",<br>    "disk_tier": "",<br>    "disk_zone": "1",<br>    "hyper_v_generation": null,<br>    "location": "uksouth",<br>    "name": "vm-datadisk-01",<br>    "os_type": null,<br>    "resource_group_name": "update-management-center-test",<br>    "source_resource_id": null,<br>    "storage_account_id": null,<br>    "storage_account_type": "Standard_LRS"<br>  }<br>}</pre> | no |
| <a name="input_nessus_groups"></a> [nessus\_groups](#input\_nessus\_groups) | The Tenable Nessus groups. | `string` | `null` | no |
| <a name="input_nessus_install"></a> [nessus\_install](#input\_nessus\_install) | Install Tenable Nessus on the virtual machine. | `string` | `false` | no |
| <a name="input_nessus_key"></a> [nessus\_key](#input\_nessus\_key) | The key to use when communicating with Tenable Nessus. | `string` | `null` | no |
| <a name="input_nessus_server"></a> [nessus\_server](#input\_nessus\_server) | The Tenable Nessus server URL. | `string` | `null` | no |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | The name of the NIC to create & associate with the virtual machine. | `string` | `null` | no |
| <a name="input_os_disk_storage_account_type"></a> [os\_disk\_storage\_account\_type](#input\_os\_disk\_storage\_account\_type) | The operating system disk storack account type. | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | The operating system disk type. | `string` | `"ReadWrite"` | no |
| <a name="input_privateip_allocation"></a> [privateip\_allocation](#input\_privateip\_allocation) | The type of private IP allocation, either Static or Dynamic. | `string` | `"Static"` | no |
| <a name="input_rc_os_sku"></a> [rc\_os\_sku](#input\_rc\_os\_sku) | The SKU of run command to use. | `string` | `null` | no |
| <a name="input_rc_script_file"></a> [rc\_script\_file](#input\_rc\_script\_file) | The path to the script file to run against the virtual machine. | `string` | `null` | no |
| <a name="input_run_command"></a> [run\_command](#input\_run\_command) | Run a custom command/script against the virtual machine using a run command extension. | `bool` | `false` | no |
| <a name="input_splunk_group"></a> [splunk\_group](#input\_splunk\_group) | The group to use when communicating with splunk. | `string` | `"hmcts_forwarders"` | no |
| <a name="input_splunk_pass4symmkey"></a> [splunk\_pass4symmkey](#input\_splunk\_pass4symmkey) | The pass4symmkey to use when communicating with splunk. | `string` | `null` | no |
| <a name="input_splunk_password"></a> [splunk\_password](#input\_splunk\_password) | The password to use when communicating with splunk. | `string` | `null` | no |
| <a name="input_splunk_username"></a> [splunk\_username](#input\_splunk\_username) | The username to use when communicating with splunk. | `string` | `null` | no |
| <a name="input_systemassigned_identity"></a> [systemassigned\_identity](#input\_systemassigned\_identity) | Enable System Assigned managed identity for the virtual machine. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the virtual machine and associated resources. | `map(string)` | n/a | yes |
| <a name="input_userassigned_identity_ids"></a> [userassigned\_identity\_ids](#input\_userassigned\_identity\_ids) | List of User Manager Identity IDs to associate with the virtual machine. | `list(string)` | `[]` | no |
| <a name="input_vm_admin_name"></a> [vm\_admin\_name](#input\_vm\_admin\_name) | The name of the admin user. | `string` | `"VMAdmin"` | no |
| <a name="input_vm_admin_password"></a> [vm\_admin\_password](#input\_vm\_admin\_password) | The Admin password for the virtual machine. | `string` | n/a | yes |
| <a name="input_vm_availabilty_zones"></a> [vm\_availabilty\_zones](#input\_vm\_availabilty\_zones) | The availability zones to deploy the VM in | `string` | n/a | yes |
| <a name="input_vm_location"></a> [vm\_location](#input\_vm\_location) | The Azure Region to deploy the virtual machine in. | `string` | `"uksouth"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The name of the Virtual Machine | `string` | n/a | yes |
| <a name="input_vm_offer"></a> [vm\_offer](#input\_vm\_offer) | The offer of the marketplace image to use. | `string` | n/a | yes |
| <a name="input_vm_private_ip"></a> [vm\_private\_ip](#input\_vm\_private\_ip) | The privat IP to assign to the virtual machine. | `string` | `null` | no |
| <a name="input_vm_public_ip_address"></a> [vm\_public\_ip\_address](#input\_vm\_public\_ip\_address) | The public IP address to assign to the virtual machine. | `string` | `null` | no |
| <a name="input_vm_publisher_name"></a> [vm\_publisher\_name](#input\_vm\_publisher\_name) | The publiser of the marketplace image to use. | `string` | n/a | yes |
| <a name="input_vm_resource_group"></a> [vm\_resource\_group](#input\_vm\_resource\_group) | The name of the resource group to deploy the virtual machine in. | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The virtual machine Size. | `string` | n/a | yes |
| <a name="input_vm_sku"></a> [vm\_sku](#input\_vm\_sku) | The SKU of the image to use. | `string` | n/a | yes |
| <a name="input_vm_subnet_id"></a> [vm\_subnet\_id](#input\_vm\_subnet\_id) | The Subnet ID to connect the virtual machine to. | `string` | n/a | yes |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | The type of the vm, either windows or linux | `string` | n/a | yes |
| <a name="input_vm_version"></a> [vm\_version](#input\_vm\_version) | The version of the image to use. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | n/a |
<!-- END_TF_DOCS -->
