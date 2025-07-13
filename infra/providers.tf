terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.95.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "11759609-bea9-4c84-969e-7fc099d8cf52"
}
