# Check names of VM NICs and IPConfig settings get computed and overridden properly

provider "azurerm" {
  features {}
  subscription_id = "64b1c6d6-1481-44ad-b620-d8fe26a2c768"
}

provider "azurerm" {
  alias = "soc"
  features {}
  subscription_id                 = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias = "cnp"
  features {}
  subscription_id                 = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias                      = "dcr"
  skip_provider_registration = "true"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

# Default variables for this test
variables {
  env                  = "nonprod"
  vm_name              = "net-test"
  vm_admin_password    = "example-$uper-$EcUrE-password" # ideally from a secret store
  vm_type              = "windows"
  vm_publisher_name    = "MicrosoftWindowsServer"
  vm_offer             = "WindowsServer"
  vm_sku               = "2022-Datacenter"
  vm_version           = "latest"
  vm_size              = "D2ds_v5"
  vm_availabilty_zones = "1"
}

run "setup" {
  module {
    source = "./tests/modules/setup"
  }
}

run "calculated_nic_name" {

  command = plan

  variables {
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_network_interface.vm_nic.name == "net-test-nic"
    error_message = "NIC name does not match VM name"
  }
}

run "custom_nic_name" {

  command = plan

  variables {
    nic_name          = "my-nic-name"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_network_interface.vm_nic.name == "my-nic-name"
    error_message = "NIC name was not overridden by var.nic_name"
  }
}

run "calculated_ipconfig_name" {

  command = plan

  variables {
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_network_interface.vm_nic.ip_configuration[0].name == "net-test-ipconfig"
    error_message = "IPConfig name does not match VM name"
  }
}

run "custom_ipconfig_name" {

  command = plan

  variables {
    ipconfig_name     = "my-ipconfig-name"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_network_interface.vm_nic.ip_configuration[0].name == "my-ipconfig-name"
    error_message = "IPConfig name was not overridden by var.ipconfig_name"
  }
}
