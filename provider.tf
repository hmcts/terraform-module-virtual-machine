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
  application = var.application
  builtFrom   = var.builtFrom
  criticality = var.criticality
}