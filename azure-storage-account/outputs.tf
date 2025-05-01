output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_account_primary_access_key" {
  value     = azurerm_storage_account.this.primary_access_key
  sensitive = true
}

output "storage_account_id" {
  value = azurerm_storage_account.this.id
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.this.primary_web_endpoint
}

output "primary_file_endpoint" {
  value = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_table_endpoint" {
  value = azurerm_storage_account.this.primary_table_endpoint
}

output "primary_queue_endpoint" {
  value = azurerm_storage_account.this.primary_queue_endpoint
}

output "storage_account_identity" {
  value = azurerm_storage_account.this.identity
}

# Research Resource Group outputs
output "research_resource_group_name" {
  value       = azurerm_resource_group.research.name
  description = "The name of the research resource group"
}

output "research_resource_group_id" {
  value       = azurerm_resource_group.research.id
  description = "The ID of the research resource group"
}

output "research_resource_group_location" {
  value       = azurerm_resource_group.research.location
  description = "The location of the research resource group"
}