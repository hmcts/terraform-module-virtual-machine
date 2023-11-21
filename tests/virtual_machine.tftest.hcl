provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "soc"
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias = "cnp"
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

variables {
  vm_type = "linux"
  vm_name = "example-vm"
  env = "nonprod"
  vm_admin_password    = "example-$uper-$EcUrE-password" # ideally from a secret store
  vm_publisher_name    = "Canonical"
  vm_offer             = "UbuntuServer"
  vm_sku               = "22.04-LTS"
  vm_size              = "D2ds_v5"
  vm_version           = "latest"
  vm_availabilty_zones = "1"
}

run "setup" {
  module {
    source = "./tests/modules/setup"
  }
}

run "example" {

  command = plan

  variables {
    vm_resource_group = run.setup.test-rg
    vm_subnet_id = run.setup.test-snet
    tags = run.setup.test-tags
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.linvm) == 1
    error_message = "Module did not stand up a linux virtual machine"
  }

}
