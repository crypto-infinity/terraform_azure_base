resource_group_names = [ "rg-prod", "rg-dev", "rg-mgmt" ]

subscription_id = "" #Enter Sub ID Here

locations = ["Italy North" , "West Europe"]

keepers_id = "dev0946"

#VNET declaration - SAMPLE

vnet_configs = {
  "vnet_prod" = {
    address_space = ["10.45.0.0/22"]
    location = "Italy North"
    name = "vnet-prod"
    resource_group_name = "rg-prod"
    environment = "prod"
  },
  "vnet_dev" = {
    address_space = ["10.46.0.0/22"]
    location = "Italy North"
    name = "vnet-dev"
    resource_group_name = "rg-dev"
    environment = "dev"
  }
}

subnets_configs = {
  "GatewaySubnet-prod" = {
    name = "GatewaySubnet"
    address_prefixes = ["10.45.1.0/27"]
    resource_group_name = "rg-prod"
    virtual_network_name = "vnet-prod"
  },
  "GatewaySubnet-dev" = {
    name = "GatewaySubnet"
    address_prefixes = ["10.46.1.0/27"]
    resource_group_name = "rg-dev"
    virtual_network_name = "vnet-dev"
  },
  "vm-subnet-prod" = {
    name = "vm-subnet-prod"
    address_prefixes = ["10.45.2.0/24"]
    resource_group_name = "rg-prod"
    virtual_network_name = "vnet-prod"
  },
  "vm-subnet-dev" = {
    name = "vm-subnet-dev"
    address_prefixes = ["10.46.2.0/24"]
    resource_group_name = "rg-dev"
    virtual_network_name = "vnet-dev"
  }
}

#VM Declaration - SAMPLE

vm_configs = {
    "srv-dc" = {
      admin_username        = "vmadmin"
      admin_password        = ""
      size                  = "Standard_D2as_v5"
      environment           = "production"
      license_type          = "Windows_Server"
      rg                    = "rg-prod"
      location              = "Italy North"
      subnet_name           = "vm-subnet-prod" 
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
    "srv-ts" = {
      admin_username        = "vmadmin"
      admin_password        = ""
      size                  = "Standard_D2as_v5"
      environment           = "dev"
      license_type          = "Windows_Server"
      rg                    = "rg-dev"
      location              = "Italy North"
      subnet_name           = "vm-subnet-dev"
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