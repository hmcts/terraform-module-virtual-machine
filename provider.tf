terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.cnp, azurerm.soc]
    }
  }
}

module "ctags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = lower(var.env)
  product     = var.product
  builtFrom   = var.builtFrom
}