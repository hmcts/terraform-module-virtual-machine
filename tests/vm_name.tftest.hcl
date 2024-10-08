# Check computer name of windows machines gets computed and overridden correctly

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

run "short_computer_name" {

  command = plan

  variables {
    vm_name           = "shortname"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_windows_virtual_machine.winvm[0].computer_name == "shortname"
    error_message = "Computer name does not match var.vm_name"
  }
}

run "long_computer_name" {

  command = plan

  variables {
    vm_name           = "reallyreallylongvirtualmachinenamethatshouldgettruncated"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_windows_virtual_machine.winvm[0].computer_name == "reallyreallylon"
    error_message = "Computer name was not truncated to 15 characters"
  }
}

run "custom_computer_name" {

  command = plan

  variables {
    vm_name           = "example-vm"
    computer_name     = "actualname"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = azurerm_windows_virtual_machine.winvm[0].computer_name == "actualname"
    error_message = "Computer name was not overriden by var.computer_name"
  }
}
