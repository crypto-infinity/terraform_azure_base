#descrizioni delle variabili dichiarate nel file .tfvars

variable "resource_group_names" {
  type = list(string)
  description = "Name of the resource groups containers."
}

variable "locations" {
  type = list(string)
  default = ["Italy North" , "West Europe"]
  description = "Name of the Azure Locations to deploy resources into."
}

variable "subscription_id" {
  type        = string
  description = "The subscription used to deploy resources."
}

variable "vnet_configs" {
  type = map(object({
    address_space = list(string)
    location = string
    name = string
    resource_group_name = string
    environment = string
  }))
  default = {
  }
}

variable "keepers_id" {
  type = string
  description = "The seed for random string generator."
  default = "dev2344356"
}

variable "subnets_configs" {
  type = map(object({
    name = string
    address_prefixes = list(string)
    resource_group_name = string
    virtual_network_name = string 
  }))
}

variable "vm_configs" {
  type = map(object({
    admin_username        = string
    admin_password        = string
    size                  = string
    environment           = string
    rg                    = string
    location              = string
    license_type          = string
    subnet_name             = string
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      offer     = string
      publisher = string
      sku       = string
      version   = string
    })
  }))
  default = {
  }
}
