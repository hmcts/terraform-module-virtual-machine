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