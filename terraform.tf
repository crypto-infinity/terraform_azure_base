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
      storage_account_name = "storagetfinfiac"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}
