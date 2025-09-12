output "app_public_ip" {
  value       = azurerm_public_ip.app_pip.ip_address
  description = "Public IP assigned to the app VM (if any)"
}

output "app_private_ip" {
  value       = azurerm_network_interface.app_nic.private_ip_address
  description = "Private IP of app VM"
}

output "db_private_ip" {
  value       = azurerm_network_interface.db_nic.private_ip_address
  description = "Private IP of db VM"
}
