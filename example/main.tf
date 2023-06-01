module "virtual-machine" {
  source = "../"

  vm_type             = "linux"
  vm_name             = "example-vm"
  vm_resource_group   = "example-resource-group"
  vm_admin_password   = "example-super-secure-password" # ideally from a secret store
  vm_subnet_id        = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/xxxx/subnets/xxx"
  vm_publisher_name   = "Canonical"
  vm_offer            = "UbuntuServer"
  vm_sku              = "22.04-LTS"
  vm_version          = "latest"
  vm_availabilty_zone = "1"
  tags                = var.common_tags
}

# only for use when building from ADO and as a quick example to get valid tags
# if you are building from Jenkins use `var.common_tags` provided by the pipeline
module "common_tags" {
  source = "github.com/hmcts/terraform-module-common-tags?ref=master"

  builtFrom   = "hmcts/terraform-module-postgresql-flexible"
  environment = var.env
  product     = "sds-platform"
}