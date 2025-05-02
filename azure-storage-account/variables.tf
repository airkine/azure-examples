variable "storage_account_name" {
  description = "The name of the storage account. Must be between 3 and 24 characters and can contain only lowercase letters and numbers."
  type        = string
  default     = "stracc"
}

variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
  default     = "rg-storage"
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
  default     = "eastus2"
}

variable "sku" {
  description = "The SKU of the storage account. Examples: Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS"
  type        = string
  default     = "Standard_LRS"
}

variable "kind" {
  description = "The kind of storage account. Can be BlobStorage, BlockBlobStorage, FileStorage, Storage or StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "enable_https_traffic_only" {
  description = "Specifies whether to allow HTTPS traffic only."
  type        = bool
  default     = true
}

variable "access_tier" {
  description = "The access tier for the storage account. Valid values are Hot and Cool."
  type        = string
  default     = "Hot"
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key."
  type        = bool
  default     = true
}

variable "is_hns_enabled" {
  description = "Hierarchical namespace enabled if set to true. Required for Azure Data Lake Storage Gen 2."
  type        = bool
  default     = false
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? Requires HNS to be enabled."
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = "Enable Large File Share."
  type        = bool
  default     = false
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7."
  type        = number
  default     = 7
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the container should be retained, between 1 and 365 days. Defaults to 7."
  type        = number
  default     = 7
}

variable "enable_versioning" {
  description = "Is versioning enabled? Required for point-in-time restore."
  type        = bool
  default     = true
}

variable "enable_change_feed" {
  description = "Is the blob service properties for change feed events enabled? Required for point-in-time restore."
  type        = bool
  default     = true
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to false."
  type        = bool
  default     = false
}

variable "blob_cors_rules" {
  description = "Blob service CORS rules configuration."
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = null
}

variable "network_rules" {
  description = "Network rules configuration for the storage account."
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "user_assigned_identity_ids" {
  description = "A list of User Assigned Managed Identity IDs to be assigned to the Storage Account. Required when identity_type contains 'UserAssigned'."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  description = "The subscription ID to use for the provider."
  type        = string
}

# File Share Soft Delete settings
variable "share_soft_delete_retention_days" {
  description = "Specifies the number of days that the share should be retained, between 1 and 365 days. Default to 7."
  type        = number
  default     = 7
}

# Blob storage protection settings
variable "enable_blob_restore_policy" {
  description = "Enable restore policy for blob service"
  type        = bool
  default     = false
}

variable "blob_restore_days" {
  description = "The number of days for blob restore policy. Value should be between 1 and 365 days."
  type        = number
  default     = 7
}

variable "enable_advanced_threat_protection" {
  description = "Enable advanced threat protection for the storage account"
  type        = bool
  default     = false
}

# Immutability policy settings
variable "enable_immutability_policy" {
  description = "Enable immutability policy for the storage account"
  type        = bool
  default     = false
}

variable "immutability_period_in_days" {
  description = "The immutability period in days, between 1 and 146000 days"
  type        = number
  default     = 365
}

variable "immutability_policy_type" {
  description = "The immutability policy type. Possible values are Locked and Unlocked."
  type        = string
  default     = "Unlocked"
  validation {
    condition     = contains(["Locked", "Unlocked"], var.immutability_policy_type)
    error_message = "The immutability policy type must be either Locked or Unlocked."
  }
}

# Replication settings
variable "allow_blob_public_access" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type        = bool
  default     = false
}

# Point-in-time restore settings
variable "enable_point_in_time_restore" {
  description = "Enable point-in-time restore for the storage account. Requires versioning and change feed enabled."
  type        = bool
  default     = true
}

variable "point_in_time_restore_days" {
  description = "The number of days for point-in-time restore. Value should be between 1 and 30 days."
  type        = number
  default     = 7
  validation {
    condition     = var.point_in_time_restore_days >= 1 && var.point_in_time_restore_days <= 30
    error_message = "Point-in-time restore days must be between 1 and 30 days."
  }
}

# Permanent delete settings
variable "enable_permanent_delete" {
  description = "Enable permanent delete for the blob service. This setting applies only to soft-deleted data."
  type        = bool
  default     = false
}

variable "permanent_delete_days" {
  description = "The number of days after which soft-deleted data is permanently deleted. Value should be greater than the retention period."
  type        = number
  default     = 90
  validation {
    condition     = var.permanent_delete_days >= 1 && var.permanent_delete_days <= 365
    error_message = "Permanent delete days must be between 1 and 365 days."
  }
}

# Infrastructure encryption settings
variable "infrastructure_encryption_enabled" {
  description = "Enable infrastructure encryption for the storage account (double encryption)"
  type        = bool
  default     = false
}

# SAS policy settings
variable "enable_sas_policy" {
  description = "Enable SAS policy for the storage account."
  type        = bool
  default     = false
}

variable "sas_expiration_period" {
  description = "The SAS expiration period in format of DD.HH:MM:SS."
  type        = string
  default     = "01.00:00:00" # 1 day
}

# Customer managed key settings
variable "enable_customer_managed_key" {
  description = "Enable customer managed key for encryption. Requires identity_type to be set."
  type        = bool
  default     = false
}

variable "key_vault_key_id" {
  description = "The ID of the Key Vault key to use for encryption."
  type        = string
  default     = null
}

# Azure Backup configuration
variable "enable_backup" {
  description = "Enable Azure Backup for the storage account"
  type        = bool
  default     = true
}

variable "backup_instance_name" {
  description = "Name of the Azure Backup instance"
  type        = string
  default     = "backup-instance"
}

variable "backup_policy_name" {
  description = "Name of the backup policy to create"
  type        = string
  default     = "default-storage-policy"
}

variable "backup_shares" {
  description = "Map of storage shares to backup. Key is a unique identifier, value is the share name."
  type        = map(string)
  default     = {}
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 30
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 9999
    error_message = "Backup retention days must be between 1 and 9999 days."
  }
}

variable "backup_schedule" {
  description = "Schedule for backups"
  type = object({
    frequency = string       # Daily or Weekly
    time      = string       # HH:MM format
    weekdays  = list(string) # List of weekdays for weekly backups
  })
  default = {
    frequency = "Daily"
    time      = "01:00"
    weekdays  = ["Monday"]
  }
  validation {
    condition     = contains(["Daily", "Weekly"], var.backup_schedule.frequency)
    error_message = "Backup frequency must be either Daily or Weekly."
  }
  validation {
    condition     = can(regex("^([01]?[0-9]|2[0-3]):[0-5][0-9]$", var.backup_schedule.time))
    error_message = "Backup time must be in format HH:MM (24-hour clock)."
  }
  validation {
    condition = alltrue([
      for day in var.backup_schedule.weekdays :
      contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], day)
    ])
    error_message = "All weekdays must be one of: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
  }
}

variable "backup_data_store_type" {
  description = "Type of data store to use for backups - VaultStore, OperationalStore"
  type        = string
  default     = "VaultStore"
  validation {
    condition     = contains(["VaultStore", "OperationalStore"], var.backup_data_store_type)
    error_message = "Backup data store type must be one of: VaultStore, OperationalStore."
  }
}

variable "backup_redundancy" {
  description = "Redundancy type for backup vault - GeoRedundant, LocallyRedundant, or ZoneRedundant"
  type        = string
  default     = "GeoRedundant"
  validation {
    condition     = contains(["GeoRedundant", "LocallyRedundant", "ZoneRedundant"], var.backup_redundancy)
    error_message = "Backup redundancy must be one of: GeoRedundant, LocallyRedundant, or ZoneRedundant."
  }
}

variable "enable_blob_backup" {
  description = "Enable Azure Backup for blob storage"
  type        = bool
  default     = true
}