variable "vm_location" {
  type        = string
  description = "The Azure Region to deploy the virtual machine in."
  default     = "uksouth"
}

variable "vm_admin_name" {
  type        = string
  description = "The name of the admin user."
  default     = "VMAdmin"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers to use, will override DNS servers set at the VNET level"
  default     = null
}

variable "nic_name" {
  type        = string
  description = "The name of the NIC to create & associate with the virtual machine."
  default     = null
}

variable "ipconfig_name" {
  type        = string
  description = "The name of the IPConfig to asssoicate with the NIC."
  default     = null
}

variable "privateip_allocation" {
  type        = string
  description = "The type of private IP allocation, either Static or Dynamic."
  default     = "Static"
}
variable "vm_private_ip" {
  type        = string
  description = "The private IP to assign to the virtual machine."
  default     = null
}

variable "os_disk_type" {
  type        = string
  description = "The operating system disk type."
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "The operating system disk storack account type."
  default     = "StandardSSD_LRS"
}

variable "custom_image_id" {
  type        = string
  description = "The ID of a custom image to use."
  default     = ""
}

variable "boot_diagnostics_enabled" {
  type        = bool
  description = "Whether to enable boot diagnostics."
  default     = true
}

variable "boot_storage_uri" {
  type        = string
  description = "The URI of the storage to use for boot diagnostics."
  default     = null
}

variable "vm_public_ip_address" {
  type        = string
  description = "The public IP address to assign to the virtual machine."
  default     = null
}

variable "managed_disks" {
  type = map(
    object(
      {
        name                     = string,
        location                 = string,
        resource_group_name      = string,
        storage_account_type     = string,
        disk_create_option       = string,
        disk_size_gb             = string,
        disk_tier                = string,
        disk_zone                = string,
        source_resource_id       = string,
        storage_account_id       = string,
        hyper_v_generation       = string,
        os_type                  = string,
        disk_lun                 = string,
        disk_caching             = string,
        attachment_create_option = string
      }
    )
  )
  description = "A map of managed disks to create & attach to the virtual machine."
  default = {
    datadisk1 = {
      name                     = "vm-datadisk-01"
      location                 = "uksouth"
      resource_group_name      = "update-management-center-test"
      storage_account_type     = "Standard_LRS"
      disk_create_option       = "Empty"
      disk_size_gb             = "128"
      disk_tier                = ""
      disk_zone                = "1"
      source_resource_id       = null
      storage_account_id       = null
      hyper_v_generation       = null
      os_type                  = null
      disk_lun                 = "10"
      disk_caching             = "ReadWrite"
      attachment_create_option = "Attach"
    }
  }
}

variable "install_splunk_uf" {
  type        = bool
  description = "Insall splunk uniforwarder on the virtual machine."
  default     = false
}

variable "splunk_username" {
  type        = string
  description = "The username to use when communicating with splunk."
  default     = null
}

variable "splunk_password" {
  type        = string
  description = "The password to use when communicating with splunk."
  default     = null
}
variable "splunk_pass4symmkey" {
  type        = string
  description = "The pass4symmkey to use when communicating with splunk."
  default     = null
}
variable "splunk_group" {
  type        = string
  description = "The group to use when communicating with splunk."
  default     = "hmcts_forwarders"
}

variable "install_dynatrace_oneagent" {
  type        = bool
  description = "Install dynatrace oneagent on the virtual machine."
  default     = true
}

variable "dynatrace_hostgroup" {
  type        = string
  description = "The hostgroup to place the virtual machine in within DynaTrace"
  default     = null
}

variable "dynatrace_server" {
  type        = string
  description = "The Dynatrace ActiveGate server URL."
  default     = null
}

variable "dynatrace_tenant_id" {
  type        = string
  description = "The Dynatrace tenant ID."
  default     = null
}

variable "dynatrace_token" {
  type        = string
  description = "The token to use when communicating with the Dynatrace ActiveGate."
  default     = null
}

variable "nessus_install" {
  type        = string
  description = "Install Tenable Nessus on the virtual machine."
  default     = false
}

variable "nessus_server" {
  type        = string
  description = "The Tenable Nessus server URL."
  default     = null
}

variable "nessus_key" {
  type        = string
  description = "The key to use when communicating with Tenable Nessus."
  default     = null
}

variable "nessus_groups" {
  type        = string
  description = "The Tenable Nessus groups."
  default     = null
}

variable "install_azure_monitor" {
  type        = bool
  description = "Install Azure Monitor on the virtual machine."
  default     = true
}

variable "run_command" {
  type        = bool
  description = "Run a custom command/script against the virtual machine using a run command extension."
  default     = false
}

variable "rc_script_file" {
  type        = string
  description = "The path to the script file to run against the virtual machine."
  default     = null
}

variable "rc_os_sku" {
  type        = string
  description = "The SKU of run command to use."
  default     = null
}

variable "encrypt_CMK" {
  type        = bool
  description = "Encrypt the disks with a customer-managed key."
  default     = false
}

variable "kv_name" {
  type        = string
  description = "The name ofthe KeyVault used to store the customer-managed key."
  default     = null
}

variable "kv_rg_name" {
  type        = string
  description = "The name of the resource group, containing the KeyVault used to store the customer-managed key."
  default     = null
}

variable "encrypt_ADE" {
  type        = bool
  description = "Encrypt the disks using Azure Disk Encryption."
  default     = false
}

variable "additional_script_uri" {
  type        = string
  description = "URI of a publically accessible script to run against the virtual machine."
  default     = null
}

variable "additional_script_name" {
  type        = string
  description = "The path to a script to run against the virtual machine."
  default     = null
}

variable "accelerated_networking_enabled" {
  type        = bool
  description = "Enable accelerated networks on the NIC for the virtual machine."
  default     = false
}

variable "custom_data" {
  type        = string
  description = "Custom data to pass to the virtual machine."
  default     = null
}

variable "userassigned_identity_ids" {
  type        = list(string)
  description = "List of User Manager Identity IDs to associate with the virtual machine."
  default     = []
}

variable "systemassigned_identity" {
  type        = bool
  description = "Enable System Assigned managed identity for the virtual machine."
  default     = false
}