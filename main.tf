resource "random_id" "id" {
  keepers = {
    # Generate a new id
    id = var.keepers_id
  }

  byte_length = 6
}

#Resource Groups
resource "azurerm_resource_group" "rgs" {
  for_each = toset(var.resource_group_names)
  location = var.locations[0]
  name     = each.value
}

#Storage account for boot diagnostics
resource "azurerm_storage_account" "boot_diagnostics" {
  name = "mgmtsa${random_id.id.hex}"

  location = var.locations[0]
  resource_group_name = "rg-mgmt"

  account_tier = "Standard"
  account_replication_type = "LRS"

  depends_on = [ azurerm_resource_group.rgs ]
}

#VNETs
resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnet_configs

  address_space       = each.value.address_space
  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name

  tags = {
    environment = each.value.environment
  }

  depends_on = [
    azurerm_resource_group.rgs,
  ]

}

#Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets_configs

  name = each.value.name
  address_prefixes = each.value.address_prefixes
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name


  depends_on = [
    azurerm_virtual_network.vnets,
    azurerm_resource_group.rgs
  ]
}

#VMs definition
resource "azurerm_windows_virtual_machine" "vms" {
  for_each              = var.vm_configs

  #Basic Tab
  name                  = each.key
  admin_password        = each.value.admin_password
  admin_username        = each.value.admin_username
  
  #License
  license_type          = each.value.license_type

  #RG and location
  location              = each.value.location
  resource_group_name   = each.value.rg
  
  #Networking
  network_interface_ids = [azurerm_network_interface.nics[each.key].id]

  #Update Management
  patch_mode            = "AutomaticByPlatform"
  reboot_setting        = "Never"
  hotpatching_enabled   = true
  
  #TPM Settings
  secure_boot_enabled   = false
  vtpm_enabled          = false

  #Sizing
  size                  = each.value.size

  #Tags
  tags = {
    environment = each.value.environment
  }
  
  additional_capabilities {
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.boot_diagnostics.primary_blob_endpoint
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  source_image_reference {
    offer     = each.value.source_image_reference.offer
    publisher = each.value.source_image_reference.publisher
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
  
  depends_on = [
    azurerm_network_interface.nics,
    azurerm_resource_group.rgs,
    azurerm_subnet.subnets
  ]
}

#Public IPs for VMs
resource "azurerm_public_ip" "ips" {
  for_each            = var.vm_configs

  #Basic tab
  name                = "${each.key}-ip"
  location            = each.value.location
  resource_group_name = each.value.rg

  #Properties
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = each.value.environment
  }

  depends_on = [
    azurerm_resource_group.rgs,
    azurerm_virtual_network.vnets
  ]
}

resource "azurerm_network_interface" "nics" {
  for_each                      = var.vm_configs

  #Basic tab
  location                      = each.value.location
  name                          = "${each.key}-nic"
  resource_group_name           = each.value.rg

  accelerated_networking_enabled = true

  tags = {
    environment = each.value.environment
  }

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ips[each.key].id
    subnet_id                     = azurerm_subnet.subnets[each.value.subnet_name].id
  }
  
  depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.ips
  ]

}

resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.vm_configs

  location            = var.locations[0]
  name                = "${each.key}-nsg"
  resource_group_name = each.value.rg

  tags = {
    environment = each.value.environment
  }

  depends_on = [
    azurerm_resource_group.rgs,
  ]
  
}

resource "azurerm_network_interface_security_group_association" "nsg_associations" {
  for_each                  = var.vm_configs

  network_interface_id      = azurerm_network_interface.nics[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id

  depends_on = [
    azurerm_network_interface.nics,
    azurerm_network_security_group.nsgs,
  ]
}

#Default RDP Rule
resource "azurerm_network_security_rule" "rules" {
  for_each                    = azurerm_network_security_group.nsgs

  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP-DATAGO"
  network_security_group_name = each.value.name
  priority                    = 100
  protocol                    = "Tcp"
  resource_group_name         = each.value.resource_group_name
  source_address_prefix       = "109.168.59.0"
  source_port_range           = "*"

  depends_on = [
    azurerm_network_security_group.nsgs,
  ]
}

# resource "azurerm_virtual_network_gateway" "vpn_gw" {
#   location            = var.location
#   name                = "dmf-vpn-gw-prod"
#   resource_group_name = var.rgs[0]
#   sku                 = "VpnGw1AZ"
#   tags = {
#     environment = "production"
#   }
#   type = "Vpn"
#   ip_configuration {
#     name                 = "default"
#     public_ip_address_id = azurerm_public_ip.pip_vpn_gw.id
#     subnet_id            = azurerm_subnet.subnet_gw.id
#   }
#   depends_on = [
#     azurerm_public_ip.pip_vpn_gw,
#     azurerm_subnet.subnet_gw,
#   ]
# }

