resource "azurerm_network_interface" "vm_nic" {
  name                          = var.nic_name == null ? "${var.vm_name}-nic" : var.nic_name
  location                      = var.vm_location
  resource_group_name           = var.vm_resource_group
  enable_accelerated_networking = var.accelerated_networking_enabled
  dns_servers                   = var.dns_servers

  ip_configuration {
    name                          = var.ipconfig_name == null ? "${var.vm_name}-ipconfig" : var.ipconfig_name
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.privateip_allocation
    private_ip_address            = var.vm_private_ip
    public_ip_address_id          = var.vm_public_ip_address
  }

  tags = merge(local.common_tags, local.enforced_tags)
}
