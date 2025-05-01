resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group for research that will contain the storage account
resource "azurerm_resource_group" "research" {
  name     = "${var.resource_group_name}-${random_string.suffix.result}"
  location = var.location
  tags = merge(var.tags, {
    Purpose = "Research"
    Environment = "Development"
    CreatedOn = formatdate("YYYY-MM-DD", timestamp())
  })
}

resource "azurerm_storage_account" "this" {
  name                            = local.storage_account_name
  resource_group_name             = azurerm_resource_group.research.name
  location                        = local.location
  account_tier                    = split("_", local.sku)[0]
  account_replication_type        = split("_", local.sku)[1]
  account_kind                    = var.kind
  access_tier                     = var.access_tier
  https_traffic_only_enabled      = var.enable_https_traffic_only
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  is_hns_enabled                  = var.is_hns_enabled
  nfsv3_enabled                   = var.nfsv3_enabled
  large_file_share_enabled        = var.large_file_share_enabled
  
  blob_properties {
    dynamic "cors_rule" {
      for_each = var.blob_cors_rules != null ? var.blob_cors_rules : []
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }

    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }

    versioning_enabled       = var.enable_versioning
    change_feed_enabled      = var.enable_change_feed
    last_access_time_enabled = var.last_access_time_enabled
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = network_rules.value.bypass
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  identity {
    type = var.identity_type
  }

  tags = var.tags
}