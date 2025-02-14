
output "vm_ips" {
    value = { for k, v in azurerm_windows_virtual_machine.vms : k => v.public_ip_address }
}