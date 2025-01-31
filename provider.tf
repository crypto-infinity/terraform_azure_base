provider "azurerm" {
  features {
  }

  subscription_id            = "" #Enter sub ID Here
  environment                = "public"
  use_msi                    = false
  use_cli                    = true
  use_oidc                   = false

}
