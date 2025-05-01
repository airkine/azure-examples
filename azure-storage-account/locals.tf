# Local values for the Azure storage account configuration
locals {
  # Process storage account name and combine with random suffix
  storage_account_name = "${lower(
    substr(replace(var.storage_account_name, "/[^a-z0-9]/", ""), 0, 16)
  )}${random_string.suffix.result}"
  
  resource_group_name = "${var.resource_group_name}-${random_string.suffix.result}"
  location            = var.location
  sku                 = var.sku
}