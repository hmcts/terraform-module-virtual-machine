
resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = var.vm_location
  resource_group_name = var.vm_resource_group

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.privateip_allocation
  }


  tags = var.tags
}