variable "vm_type" {
  type        = string
  description = "The type of the vm, either 'windows' or 'linux'"
}

variable "vm_name" {
  type        = string
  description = "The name of the Virtual Machine"
}

variable "vm_resource_group" {
  type        = string
  description = "The name of the resource group to deploy the virtual machine in."
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "The Admin password for the virtual machine."
}

variable "vm_subnet_id" {
  type        = string
  description = "The Subnet ID to connect the virtual machine to."
}

variable "vm_publisher_name" {
  type        = string
  description = "The publiser of the marketplace image to use."
}

variable "vm_offer" {
  type        = string
  description = "The offer of the marketplace image to use."
}

variable "vm_sku" {
  type        = string
  description = "The SKU of the image to use."
}

variable "vm_size" {
  type        = string
  description = "The virtual machine Size."
}

variable "vm_version" {
  type        = string
  description = "The version of the image to use."
}

variable "vm_availabilty_zones" {
  type        = string
  description = "The availability zones to deploy the VM in"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to the virtual machine and associated resources."
}
