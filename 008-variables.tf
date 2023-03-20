variable "vm_type" {
  type        = string
  description = "Enter Type of the VM"
}


variable "vm_name" {}
variable "vm_location" {}

variable "vm_resource_group" {
}

variable "vm_size" {
  default = "Standard_F1"
}


variable "vm_admin_name" {
  default = "VMAdmin"
}

variable "vm_admin_password" {
}
variable "nic_name" {
}
variable "dns_servers" {
  type        = list(string)
  description = "DNS servers to use, will override DNS servers set at the VNET level"
  default     = null
}
variable "ipconfig_name" {
}

variable "vm_subnet_id" {
}
variable "privateip_allocation" {
  default = "Static"
}
variable "vm_private_ip" {
  default = null
}

variable "os_disk_type" {
  default = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  default = "StandardSSD_LRS"
}

variable "custom_image_id" {
  default = ""
}
variable "vm_publisher_name" {

}

variable "vm_offer" {

}

variable "vm_sku" {
}
variable "vm_version" {}


variable "boot_diagnostics_enabled" {
  default = true
}
variable "boot_storage_uri" {
  default = null
}

variable "marketplace_sku" {
  default = null
}
variable "marketplace_publisher" {
  default = null
}
variable "marketplace_product" {
  default = null
}

variable "vm_public_ip_address" {
  default = null
}

variable "managed_disks" {
  type = map(any)
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


########### Extensions variables

variable "install_splunk_uf" {
  default = false
}

variable "splunk_username" {
  default = null
}
variable "splunk_password" {
  default = null
}
variable "splunk_pass4symmkey" {
  default = null
}
variable "splunk_group" {
  default = "hmcts_forwarders"
}
#dynatrace

variable "install_dynatrace_oneagent" {
  type    = bool
  default = true
}

variable "dynatrace_hostgroup" {
  default = null
}
variable "dynatrace_server" {
  default = null
}

variable "dynatrace_tenant_id" {
  default = null
}

variable "dynatrace_token" {
  default = null
}


# Nessus
variable "nessus_install" {
  default = false
}

variable "nessus_server" {
  default = null
}

variable "nessus_key" {
  default = null
}

variable "nessus_groups" {
  default = null
}

variable "vm_availabilty_zones" {}

############


variable "install_azure_monitor" {
  default = true
}

########### Run Command #########
variable "run_command" {
  default = false
}
variable "rc_script_file" { default = null }

variable "rc_os_sku" {
  default = null
}
#########################

##### disk encryption #####
variable "encrypt_CMK" {
  type    = bool
  default = false
}
variable "kv_name" {
  type    = string
  default = null
}
variable "kv_rg_name" {
  type    = string
  default = null
}

variable "encrypt_ADE" {
  type    = bool
  default = false
}

##########

variable "additional_script_uri" {
  default = null
}
variable "additional_script_name" {
  default = null
}

variable "accelerated_networking_enabled" {
  default = false
}

variable "custom_data" {
  default = null
}

variable "tags" {}

locals {
  #   dynamic_storage_image    = var.custom_image_id != "" || var.vm_publisher_name != "" ? { dummy_create = true } : {}
  dynamic_boot_diagnostics = var.boot_diagnostics_enabled == true ? { dummy_create = true } : {}
}
