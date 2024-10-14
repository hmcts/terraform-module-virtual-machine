terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "4.5.0"
      configuration_aliases = [azurerm.cnp, azurerm.soc, azurerm.dcr]
    }
  }
}
