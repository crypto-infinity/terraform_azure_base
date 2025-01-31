output "vm_passwords" {
  value = azurerm_windows_virtual_machine.vms.admin_password
}

output "vm_ips" {
  value = azurerm_windows_virtual_machine.vms.public_ip_address
}