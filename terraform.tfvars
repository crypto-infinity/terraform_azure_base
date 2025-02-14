resource_group_names = [ "sl-rg-prod", "sl-rg-dev", "sl-rg-mgmt", "sl-rg-vdi" ]

subscription_id = "" #Enter Sub ID Here

locations = ["Italy North", "West Europe"] #Primary region at the beginning

keepers_id = "dev0946"

#VNET declaration

vnet_configs = {
  "vnet_prod" = {
    address_space = ["10.50.0.0/22"]
    location = "Italy North"
    name = "sl-vnet-prod"
    resource_group_name = "sl-rg-prod"
    environment = "prod"
  },
  "vnet_dev" = {
    address_space = ["10.51.0.0/22"]
    location = "Italy North"
    name = "sl-vnet-dev"
    resource_group_name = "sl-rg-dev"
    environment = "dev"
  }
}

#Subnets

subnets_configs = {
  "GatewaySubnet-prod" = {
    name = "GatewaySubnet"
    address_prefixes = ["10.50.1.0/27"]
    resource_group_name = "sl-rg-prod"
    virtual_network_name = "sl-vnet-prod"
  },
  "GatewaySubnet-dev" = {
    name = "GatewaySubnet"
    address_prefixes = ["10.51.1.0/27"]
    resource_group_name = "sl-rg-dev"
    virtual_network_name = "sl-vnet-dev"
  },
  "vm-subnet-prod" = {
    name = "vm-subnet-prod"
    address_prefixes = ["10.50.2.0/24"]
    resource_group_name = "sl-rg-prod"
    virtual_network_name = "sl-vnet-prod"
  },
  "vm-subnet-dev" = {
    name = "vm-subnet-dev"
    address_prefixes = ["10.51.2.0/24"]
    resource_group_name = "sl-rg-dev"
    virtual_network_name = "sl-vnet-dev"
  }
}

#VM Declaration

vm_configs = {
    "sl-srv-db" = {
      admin_username        = "vmadmin"
      admin_password        = ""
      size                  = "Standard_D4as_v5"
      environment           = "production"
      license_type          = "Windows_Server"
      rg                    = "sl-rg-prod"
      location              = "Italy North"
      subnet_name           = "vm-subnet-prod"
      ip_configuration      = "10.50.2.5"
      secure_boot_enabled   = true
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Premium_ZRS"
      }
      source_image_reference = {
        offer     = "WindowsServer"
        publisher = "MicrosoftWindowsServer"
        sku       = "2022-datacenter-azure-edition-hotpatch"
        version   = "latest"
      }
    },
    "sl-srv-web" = {
      admin_username        = "vmadmin"
      admin_password        = ""
      size                  = "Standard_D2as_v5"
      environment           = "prod"
      license_type          = "Windows_Server"
      rg                    = "sl-rg-prod"
      location              = "Italy North"
      subnet_name           = "vm-subnet-prod"
      ip_configuration      = "10.50.2.6"
      secure_boot_enabled   = true
      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Premium_ZRS"
      }
      source_image_reference = {
        offer     = "WindowsServer"
        publisher = "MicrosoftWindowsServer"
        sku       = "2022-datacenter-azure-edition-hotpatch"
        version   = "latest"
      }
    }
}

rsv_name = "sl-rsv"

vpn_gw_name = "sl-vpngw"