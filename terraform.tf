terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.99.0"

    }
  }
  backend "azurerm" {
      subscription_id = "" #Enter Sub ID Here
      resource_group_name  = "rg-iac"
      storage_account_name = "" #Set RG-IAC storage account name created at point 4
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}
