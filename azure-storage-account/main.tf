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
    Purpose     = "Research"
    Environment = "Development"
    CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
  })
}

# User-assigned Managed Identity for the storage account
resource "azurerm_user_assigned_identity" "storage_identity" {
  name                = "id-storage-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.research.name
  location            = var.location
  tags = merge(var.tags, {
    Purpose     = "Storage Authentication"
    Environment = "Development"
    CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
  })
}

resource "azurerm_storage_account" "this" {
  name                              = local.storage_account_name
  resource_group_name               = azurerm_resource_group.research.name
  location                          = var.location
  account_tier                      = split("_", var.sku)[0]
  account_replication_type          = split("_", var.sku)[1]
  account_kind                      = var.kind
  access_tier                       = var.access_tier
  https_traffic_only_enabled        = var.enable_https_traffic_only
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  is_hns_enabled                    = var.is_hns_enabled
  nfsv3_enabled                     = var.nfsv3_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

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
      days                     = var.blob_soft_delete_retention_days
      permanent_delete_enabled = var.enable_permanent_delete
    }

    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }

    versioning_enabled       = var.enable_versioning
    change_feed_enabled      = var.enable_change_feed
    last_access_time_enabled = var.last_access_time_enabled

    restore_policy {
      days = var.blob_restore_days < var.blob_soft_delete_retention_days ? var.blob_restore_days : var.blob_soft_delete_retention_days - 1
    }
  }

  share_properties {
    retention_policy {
      days = var.share_soft_delete_retention_days
    }

    # Optional SMB settings if needed
    dynamic "smb" {
      for_each = var.is_hns_enabled ? [] : [1]
      content {
        versions                        = ["SMB2.1", "SMB3.0", "SMB3.1.1"]
        authentication_types            = ["NTLMv2"]
        kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]
        channel_encryption_type         = ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"]
      }
    }
  }

  dynamic "sas_policy" {
    for_each = var.enable_sas_policy ? [1] : []
    content {
      expiration_period = var.sas_expiration_period
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.enable_customer_managed_key ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = length(var.user_assigned_identity_ids) > 0 ? var.user_assigned_identity_ids[0] : azurerm_user_assigned_identity.storage_identity.id
    }
  }

  dynamic "immutability_policy" {
    for_each = var.enable_immutability_policy ? [1] : []
    content {
      allow_protected_append_writes = true
      state                         = var.immutability_policy_type
      period_since_creation_in_days = var.immutability_period_in_days
    }
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
    identity_ids = contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type) ? (
      length(var.user_assigned_identity_ids) > 0 ? var.user_assigned_identity_ids : [azurerm_user_assigned_identity.storage_identity.id]
    ) : []
  }

  tags = merge(var.tags, {
    Purpose     = "Backup Services"
    Environment = "Testing"
    CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
  })
}

# Create file shares for backup if enabled
resource "azurerm_storage_share" "backup_shares" {
  for_each = var.enable_backup ? var.backup_shares : {}

  name               = each.value
  storage_account_id = azurerm_storage_account.this.id
  quota              = 50 # GB

  acl {
    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
    }
  }
}

# Azure Backup configuration
resource "azurerm_data_protection_backup_vault" "backup_vault" {
  for_each = var.enable_backup ? { enabled = true } : {}

  name                = "bv-${local.storage_account_name}"
  resource_group_name = azurerm_resource_group.research.name
  location            = var.location
  datastore_type      = var.backup_data_store_type
  redundancy          = var.backup_redundancy

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, {
    Purpose     = "Backup Services"
    Environment = "Production"
    CreatedOn   = formatdate("YYYY-MM-DD", timestamp())
  })
}

# Create backup policy
resource "azurerm_data_protection_backup_policy_disk" "backup_policy" {
  for_each = var.enable_backup ? { enabled = true } : {}

  name                            = var.backup_policy_name
  vault_id                        = azurerm_data_protection_backup_vault.backup_vault["enabled"].id
  backup_repeating_time_intervals = ["R/2021-05-01T${var.backup_schedule.time}:00+00:00/P1D"]
  default_retention_duration      = "P${var.backup_retention_days}D"

  # Create a tiered rule for monthly backups retained longer
  # retention_rule {
  #   name     = "Monthly"
  #   duration = "P12M"
  #   priority = 25
  #   criteria {
  #     absolute_criteria = "FirstOfDay"
  #   }
  # }

  # Keep weekly backups for 3 months
  retention_rule {
    name     = "Weekly"
    duration = "P3M"
    priority = 20
    criteria {
      absolute_criteria = "FirstOfWeek"
    }
  }
}

# Grant permissions for backup
resource "azurerm_role_assignment" "storage_backup_contributor" {
  for_each = var.enable_backup ? { enabled = true } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].identity[0].principal_id
}

# Create backup instances for each share
resource "azurerm_data_protection_backup_instance_disk" "backup_instances" {
  for_each = var.enable_backup ? var.backup_shares : {}

  name                         = "${each.key}-backup-instance"
  vault_id                     = azurerm_data_protection_backup_vault.backup_vault["enabled"].id
  location                     = var.location
  disk_id                      = azurerm_storage_account.this.id
  snapshot_resource_group_name = azurerm_resource_group.research.name
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.backup_policy["enabled"].id

  depends_on = [
    azurerm_role_assignment.storage_backup_contributor,
    azurerm_storage_share.backup_shares
  ]
}

# Create blob backup policy. Commented out due to bug in azurerm provider https://github.com/hashicorp/terraform-provider-azurerm/issues/26321
# resource "azurerm_data_protection_backup_policy_blob_storage" "blob_backup_policy" {
#   for_each = var.enable_blob_backup ? { enabled = true } : {}

#   name               = "blob-backup-policy"
#   vault_id           = azurerm_data_protection_backup_vault.backup_vault["enabled"].id  
#   backup_repeating_time_intervals = [
#     "R/2025-05-01T22:00:00Z/PT24H" # Daily at 10:00 PM UTC
#   ]
#   retention_rule {
#     name     = "Daily"
#     priority = 10

#      # 30 days 
#     criteria {
#       absolute_criteria = "FirstOfDay"
#     }
#     life_cycle {
#       data_store_type = "VaultStore"
#       duration = "P30D" # 30 days
#     }
#   }

#   # Adding required argument for retention duration
#   # Specifies the default retention duration for operational data.
#   # The value "P30D" follows the ISO 8601 duration format, where:
#   # - "P" indicates the duration period.
#   # - "30D" specifies a duration of 30 days.
#   operational_default_retention_duration = "P30D"
# }

resource "azapi_resource" "blob_backup_policy" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  name                      = "default_blob_backup_policy"
  type                      = "Microsoft.DataProtection/backupVaults/backupPolicies@2025-01-01"
  parent_id                 = azurerm_data_protection_backup_vault.backup_vault[each.key].id
  location                  = azurerm_data_protection_backup_vault.backup_vault[each.key].location
  schema_validation_enabled = false

  body = {
    properties = {
      objectType = "BackupPolicy"
      datasourceTypes = [
        "Microsoft.Storage/storageAccounts/blobServices"
      ]

      policyRules = [

        # Retention Rule 1 - Operational Store, 30 days
        {
          name       = "Default"
          objectType = "AzureRetentionRule"
          isDefault  = true

          lifecycles = [
            {
              deleteAfter = {
                objectType = "AbsoluteDeleteOption"
                duration   = "P30D"
              }
              targetDataStoreCopySettings = []
              sourceDataStore = {
                dataStoreType = "OperationalStore"
                objectType    = "DataStoreInfoBase"
              }
            }
          ]
        },

        # Retention Rule 2 - Vault Store, 90 days
        {
          name       = "Default"
          objectType = "AzureRetentionRule"
          isDefault  = true

          lifecycles = [
            {
              deleteAfter = {
                objectType = "AbsoluteDeleteOption"
                duration   = "P90D"
              }
              targetDataStoreCopySettings = []
              sourceDataStore = {
                dataStoreType = "VaultStore"
                objectType    = "DataStoreInfoBase"
              }
            }
          ]
        },

        # Backup Schedule Rule
        {
          name       = "BackupDaily"
          objectType = "AzureBackupRule"

          backupParameters = {
            backupType = "Discrete"
            objectType = "AzureBackupParams"
          }

          trigger = {
            objectType = "ScheduleBasedTriggerContext"
            timeZone   = "Coordinated Universal Time"

            schedule = {
              repeatingTimeIntervals = [
                "R/2025-05-01T10:00:00+00:00/P1D"
              ]
            }

            taggingCriteria = [
              {
                tagInfo = {
                  tagName = "Default"
                  id      = "Default_"
                }
                taggingPriority = 99
                isDefault       = true
              }
            ]
          }

          dataStore = {
            dataStoreType = "VaultStore"
            objectType    = "DataStoreInfoBase"
          }
        }
      ]
    }
  }
}

# Create a container for blob backups
resource "azurerm_storage_container" "backup_container" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  name                  = "blob-backups"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Grant additional Storage Blob Data Contributor role for blob backups
resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].identity[0].principal_id
}

# Grant additional Storage Account Contributor role for blob backups
resource "azurerm_role_assignment" "storage_account_contributor" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].identity[0].principal_id
}

# Grant Reader role for blob backups
resource "azurerm_role_assignment" "reader_role" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].identity[0].principal_id

  depends_on = [
    azurerm_data_protection_backup_vault.backup_vault
  ]
}

# Grant Backup Reader role for blob backups
resource "azurerm_role_assignment" "backup_reader_role" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Backup Reader"
  principal_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].identity[0].principal_id

  depends_on = [
    azurerm_data_protection_backup_vault.backup_vault
  ]
}

# Create blob backup instance
resource "azurerm_data_protection_backup_instance_blob_storage" "blob_backup_instance" {
  for_each = var.enable_blob_backup ? { enabled = true } : {}

  name             = "blob-backup-instance"
  vault_id         = azurerm_data_protection_backup_vault.backup_vault["enabled"].id
  location         = var.location
  backup_policy_id = azapi_resource.blob_backup_policy["enabled"].id

  storage_account_id = azurerm_storage_account.this.id

  depends_on = [
    azurerm_role_assignment.storage_blob_data_contributor,
    azurerm_role_assignment.storage_account_contributor,
    azurerm_role_assignment.reader_role,
    azurerm_role_assignment.backup_reader_role,
    azurerm_storage_container.backup_container
  ]
}