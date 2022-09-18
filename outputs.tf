output "resource_group_id" {
  description = "to get the resource group id"
  value = azurerm_resource_group.resource_group.id
}

output "vm_ip_address" {
  description = "to get the public ip address of virtual machines"
  value = data.azurerm_public_ip.public_ip.*.ip_address
}
