terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.cnp, azurerm.soc]
    }
  }
}


module "ctags" {
  source      = "github.com/hmcts/terraform-module-common-tags?ref=master"
  environment = "ptlsbox"
  product     = "sds-platform"
  builtFrom   = "hmcts/terraform-module-virtual-machine"
}