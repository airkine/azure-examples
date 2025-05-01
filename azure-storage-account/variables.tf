variable "storage_account_name" {
  description = "The name of the storage account. Must be between 3 and 24 characters and can contain only lowercase letters and numbers."
  type        = string
  default = "stracc"
}

variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
  default = "rg-storage"
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
  default = "eastus2"
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
  description = "Is versioning enabled? Default to false."
  type        = bool
  default     = false
}

variable "enable_change_feed" {
  description = "Is the blob service properties for change feed events enabled? Default to false."
  type        = bool
  default     = false
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

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  description = "The subscription ID to use for the provider."
  type        = string
}