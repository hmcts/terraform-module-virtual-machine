provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "soc"
  resource_provider_registrations = "all"
  features {}
  subscription_id = "8ae5b3b6-0b12-4888-b894-4cec33c92292"
}

provider "azurerm" {
  alias = "cnp"
  resource_provider_registrations = "all"
  features {}
  subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}

provider "azurerm" {
  alias                           = "dcr"
  resource_provider_registrations = "all"
  features {}
  subscription_id = var.env == "prod" || var.env == "production" ? "8999dec3-0104-4a27-94ee-6588559729d1" : var.env == "sbox" || var.env == "sandbox" ? "bf308a5c-0624-4334-8ff8-8dca9fd43783" : "1c4f0704-a29e-403d-b719-b90c34ef14c9"
}
