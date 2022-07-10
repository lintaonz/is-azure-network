provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "c4855b85-e4fb-4ae6-9db6-34dc74d21cc4"
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = "5b74d5cd-8e57-4e60-b745-fb2d0c394320"
  features {}
}