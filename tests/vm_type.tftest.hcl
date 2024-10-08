# Check the correct VM resource gets stood up for windows and linux machines

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
  vm_name              = "example-vm"
  env                  = "nonprod"
  vm_admin_password    = "example-$uper-$EcUrE-password" # ideally from a secret store
  vm_size              = "D2ds_v5"
  vm_availabilty_zones = "1"
}

# The virtual machine module depends on some external infrastructure that needs
# to be present before we can run a plan against it. The 'setup' run stands up
# a resource group, virtual network, subnet and common tags. I think setup
# needs to be applied in order to know the value of the outputs. This creates
# actual resources in azure, but they only last for the duration of the tests
# and are automatically destroyed at the end of the tests. This does mean that
# tests can't be run concurrently, so we will need to add some logic to the
# pipeline to prevent concurrent jobs.
run "setup" {
  module {
    source = "./tests/modules/setup"
  }
}

# The actual test infrastructure doesn't need to be applied. We can run
# assertions against the state created by a plan. The only exception is if we
# Need to test against values that are only known after an apply. This includes
# things like resource IDs, IP addresses and VM extensions.
run "linux_vm" {

  command = plan

  variables {
    vm_type           = "linux"
    vm_publisher_name = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "22.04-LTS"
    vm_version        = "latest"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.linvm) == 1
    error_message = "Module did not stand up a linux virtual machine"
  }
  assert {
    condition     = length(azurerm_windows_virtual_machine.winvm) == 0
    error_message = "Module stood up a windows virtual machine"
  }
}

run "linux_vm_case_sensitivity" {

  command = plan

  variables {
    vm_type           = "Linux"
    vm_publisher_name = "Canonical"
    vm_offer          = "UbuntuServer"
    vm_sku            = "22.04-LTS"
    vm_version        = "latest"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.linvm) == 1
    error_message = "Module did not stand up a linux virtual machine"
  }
  assert {
    condition     = length(azurerm_windows_virtual_machine.winvm) == 0
    error_message = "Module stood up a windows virtual machine"
  }
}

run "windows_vm" {

  command = plan

  variables {
    vm_type           = "windows"
    vm_publisher_name = "MicrosoftWindowsServer"
    vm_offer          = "WindowsServer"
    vm_sku            = "2022-Datacenter"
    vm_version        = "latest"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.linvm) == 0
    error_message = "Module stood up a linux virtual machine"
  }
  assert {
    condition     = length(azurerm_windows_virtual_machine.winvm) == 1
    error_message = "Module did not stand up a windows virtual machine"
  }
}

run "windows_vm_case_sensitivity" {

  command = plan

  variables {
    vm_type           = "Windows"
    vm_publisher_name = "MicrosoftWindowsServer"
    vm_offer          = "WindowsServer"
    vm_sku            = "2022-Datacenter"
    vm_version        = "latest"
    vm_resource_group = run.setup.resource_group
    vm_subnet_id      = run.setup.subnet
    tags              = run.setup.common_tags
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.linvm) == 0
    error_message = "Module stood up a linux virtual machine"
  }
  assert {
    condition     = length(azurerm_windows_virtual_machine.winvm) == 1
    error_message = "Module did not stand up a windows virtual machine"
  }
}
