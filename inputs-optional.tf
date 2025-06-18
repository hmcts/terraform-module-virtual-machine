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

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "The Admin password for the virtual machine. This or vm_admin_ssh_key must be set."
  default     = null
  validation {
    condition     = var.disable_password_authentication ? true : var.vm_admin_password != null
    error_message = "The admin password must be set."
  }
}

variable "vm_admin_ssh_key" {
  type        = string
  description = "The SSH public key to use for the admin user. This or vm_admin_password must be set."
  default     = null
  validation {
    condition     = var.disable_password_authentication ? var.vm_admin_ssh_key != null : true
    error_message = "The SSH public key must be set."
  }
}

variable "disable_password_authentication" {
  type        = bool
  description = "Disable password authentication on the virtual machine."
  default     = false
}

variable "computer_name" {
  description = "Override the computer name of the VM. If not set, the computer name will be the same as the VM name truncated to 15 characters (Windows only)."
  default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "If patch_assessment_mode AutomaticByPlatform then the provision_vm_agent field must be set to true."
  default     = true
}

variable "vm_patch_assessment_mode" {
  type        = string
  description = "Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are AutomaticByPlatform or ImageDefault. Defaults to ImageDefault"
  default     = "AutomaticByPlatform"
}

variable "vm_patch_mode" {
  type        = string
  description = "Used to set Azure Update Manager configuration. Possible values are Manual, AutomaticByOS and AutomaticByPlatform. Defaults to AutomaticByOS."
  default     = "AutomaticByPlatform"
}

variable "aum_schedule_enable" {
  type        = bool
  description = "Specifies whether to skip platform scheduled patching when a user schedule is associated with the VM. Defaults to false. HMCTS use this to set AUM as Customer Managed Schedules"
  default     = true
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

variable "os_disk_size_gb" {
  type        = string
  description = "The operating system disk size in GB."
  default     = "128"
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
  default     = {}
}

# Splunk UF
variable "install_splunk_uf" {
  type        = bool
  description = "Install splunk uniforwarder on the virtual machine."
  default     = true
}

variable "remove_splunk_uf" {
  type        = bool
  description = "Remove splunk uniforwarder on the virtual machine."
  default     = true
}

variable "splunk_username" {
  type        = string
  description = "Splunk universal forwarder local admin username."
  default     = null
}

variable "splunk_password" {
  type        = string
  description = "Splunk universal forwarder local admin password."
  default     = null
}
variable "splunk_pass4symmkey" {
  type        = string
  description = "Splunk universal forwarder communication security key."
  default     = null
}
variable "splunk_group" {
  type        = string
  description = "Splunk universal forwarder global target group."
  default     = "hmcts_forwarders"
}

# Dynatrace OneAgent
variable "install_dynatrace_oneagent" {
  type        = bool
  description = "Install dynatrace OneAgent."
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
  default     = ""
}

variable "dynatrace_token" {
  type        = string
  description = "The token to use when communicating with the Dynatrace ActiveGate."
  default     = ""
}

# Nessus Agent
variable "nessus_install" {
  type        = bool
  description = "Install Tenable Nessus on the virtual machine."
  default     = true
}

variable "nessus_server" {
  type        = string
  description = "The Tenable Nessus server URL."
  default     = ""
}

variable "nessus_key" {
  type        = string
  description = "The key to use when communicating with Tenable Nessus."
  default     = null
}

variable "nessus_groups" {
  type        = string
  description = "The Tenable Nessus group name."
  default     = "Platform-Operation-Bastions"
}

# Azure Monitor
variable "install_azure_monitor" {
  type        = bool
  description = "Install Azure Monitor Agent."
  default     = true
}

# Run Command Variables
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

variable "run_command_sa_key" {
  description = "SA key for the run command"
  default     = ""
  sensitive   = true
}

variable "run_cis" {
  type        = bool
  default     = false
  description = "Install CIS hardening using run command script?"
}
variable "run_xdr_collector" {
  type        = bool
  default     = false
  description = "Install XDR collectors using run command script?"
}

variable "run_xdr_agent" {
  type        = bool
  default     = false
  description = "Install XDR agents using run command script?"
}

variable "install_docker" {
  type        = bool
  description = "Install Docker and Docker Compose - Ubuntu only 20.04+"
  default     = false
}

variable "enable_winrm" {
  description = "Enable WinRM for Windows VMs. Used by Ansible."
  type        = bool
  default     = false
}

variable "enable_port80" {
  description = "Enable port 80 for Windows VMs using run command script?"
  type        = bool
  default     = false

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

variable "custom_script_extension_name" {
  description = "Overwrite custom script extension name label in bootstrap module."
  type        = string
  default     = "HMCTSVMBootstrap"
}

variable "xdr_tags" {
  description = "XDR specific Tags"
  type        = string
  default     = ""
}

variable "enable_availability_set" {
  description = "Enable availability set or not, default is false"
  type        = bool
  default     = false
}

variable "availability_set_name" {
  description = "Name of the availability_set"
  type        = string
  default     = ""
}

variable "platform_fault_domain_count" {
  description = "Specifies the number of fault domains that are used. Defaults to 2"
  type        = number
  default     = 2
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
  default     = null
}
variable "soc_vault_rg" {
  description = "The name of the resource group where the SOC Key Vault is located."
  type        = string
  default     = "soc-core-infra-prod-rg"
}

variable "soc_vault_name" {
  description = "The name of the SOC Key Vault."
  type        = string
  default     = "soc-prod"
}

variable "deploy_entra_extension" {
  description = "Install Entra Extension linux VM"
  default     = false
}

variable "rbac_config" {
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
  description = "Map containing the RBAC configuration for the VM"
  default     = {}
}

variable "aad_type_handler_version" {
  description = "AADSSHLoginForLinux type handler version"
  type        = string
  default     = "1.0"

}

variable "enable_fileshare" {
  type        = bool
  default     = false
  description = "Enabling port 80 Glimr using run command script?"
}

variable "mount_sa" {
  type        = string
  default     = ""
  description = "Storage account name to mount file share"

}

variable "mount_fs" {
  type        = string
  default     = ""
  description = "File share name to mount"
}
