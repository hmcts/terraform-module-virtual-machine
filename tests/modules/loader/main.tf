data "azurerm_resource_group" "test" {
    name     = "vm_test_rg"
}

data "azurerm_virtual_network" "test" {
  name                = "vm-test-vnet"
  resource_group_name = data.azurerm_resource_group.test.name
}

data "azurerm_subnet" "test" {
  name                 = "vm-test-subnet"
  resource_group_name  = data.azurerm_resource_group.test.name
  virtual_network_name = data.azurerm_virtual_network.test.name
}