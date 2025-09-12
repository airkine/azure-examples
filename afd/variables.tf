variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create or use for Front Door and related resources."
}

variable "resource_group_location" {
  type        = string
  description = "Azure location for the resource group (for example: eastus2)."
}

variable "site1_eastus2_storage_account_name" {
  type        = string
  description = "Storage account name for site1 in EastUS2 (used for static website/content)."
}

variable "site1_eastus2_location" {
  type        = string
  description = "Azure region for the EastUS2 storage account used by site1."
}

variable "site1_centralus_storage_account_name" {
  type        = string
  description = "Storage account name for site1 in CentralUS (used for static website/content)."
}

variable "site1_centralus_location" {
  type        = string
  description = "Azure region for the CentralUS storage account used by site1."
}

variable "storage_account_tier" {
  type        = string
  description = "SKU tier for the storage accounts (e.g., Standard)."
}

variable "storage_account_replication_type" {
  type        = string
  description = "Replication type for storage accounts (e.g., LRS, GRS)."
}

variable "storage_account_kind" {
  type        = string
  description = "Kind of storage account (e.g., StorageV2)."
}

variable "static_website_index_document" {
  type        = string
  description = "File name to use as the index document for the static website (e.g., index.html)."
}

variable "static_website_error_document" {
  type        = string
  description = "File name to use as the error document for the static website (e.g., 404.html)."
}

variable "fd_profile_name" {
  type        = string
  description = "Name of the Front Door profile to create."
}

variable "fd_sku_name" {
  type        = string
  description = "SKU name for Front Door (for example: Standard_AzureFrontDoor)."
}

variable "fd_endpoint_name" {
  type        = string
  description = "Endpoint name to use for the Front Door instance."
}

variable "site1_origin_group_name" {
  type        = string
  description = "Name for the origin group used by site1 in Front Door."
}

variable "site1_session_affinity_enabled" {
  type        = bool
  description = "Enable session affinity on the origin group to route requests from the same client to the same origin."
}

variable "site1_lb_sample_size" {
  type        = number
  description = "Number of samples the load balancer uses when calculating health for origins."
}

variable "site1_lb_successful_samples_required" {
  type        = number
  description = "Number of successful samples required for an origin to be considered healthy."
}

variable "site1_health_probe_path" {
  type        = string
  description = "Path used for health probes against origin servers (for example: /health)."
}

variable "site1_health_probe_protocol" {
  type        = string
  description = "Protocol used for health probes (HTTP or HTTPS)."
}

variable "site1_health_probe_interval" {
  type        = number
  description = "Interval in seconds between health probes."
}

variable "site1_health_probe_request_type" {
  type        = string
  description = "Request type for the health probe (GET/HEAD)."
}

variable "site1_eastus2_origin_name" {
  type        = string
  description = "Origin name for the EastUS2 instance of site1."
}

variable "site1_eastus2_origin_priority" {
  type        = number
  description = "Priority for the EastUS2 origin (lower value = higher priority)."
}

variable "site1_eastus2_origin_weight" {
  type        = number
  description = "Weight for the EastUS2 origin when load balancing."
}

variable "site1_eastus2_origin_enabled" {
  type        = bool
  description = "Whether the EastUS2 origin is enabled for traffic."
}

variable "site1_eastus2_http_port" {
  type        = number
  description = "HTTP port number for the EastUS2 origin (commonly 80)."
}

variable "site1_eastus2_https_port" {
  type        = number
  description = "HTTPS port number for the EastUS2 origin (commonly 443)."
}

variable "site1_eastus2_cert_name_check_enabled" {
  type        = bool
  description = "Enable certificate name check for the EastUS2 origin host."
}

variable "site1_centralus_origin_name" {
  type        = string
  description = "Origin name for the CentralUS instance of site1."
}

variable "site1_centralus_origin_priority" {
  type        = number
  description = "Priority for the CentralUS origin (lower value = higher priority)."
}

variable "site1_centralus_origin_weight" {
  type        = number
  description = "Weight for the CentralUS origin when load balancing."
}

variable "site1_centralus_origin_enabled" {
  type        = bool
  description = "Whether the CentralUS origin is enabled for traffic."
}

variable "site1_centralus_http_port" {
  type        = number
  description = "HTTP port number for the CentralUS origin (commonly 80)."
}

variable "site1_centralus_https_port" {
  type        = number
  description = "HTTPS port number for the CentralUS origin (commonly 443)."
}

variable "site1_centralus_cert_name_check_enabled" {
  type        = bool
  description = "Enable certificate name check for the CentralUS origin host."
}

variable "route_site1_name" {
  type        = string
  description = "Name of the Front Door route for site1."
}

variable "route_site1_patterns_to_match" {
  type        = list(string)
  description = "List of URL path patterns that the route should match (for example: [\"/*\"])."
}

variable "route_site1_supported_protocols" {
  type        = list(string)
  description = "Protocols supported by the route (e.g., [\"Http\", \"Https\"])."
}

variable "route_site1_forwarding_protocol" {
  type        = string
  description = "How Front Door forwards the protocol to the origin (e.g., MatchRequest, HttpOnly, HttpsOnly)."
}

variable "route_site1_https_redirect_enabled" {
  type        = bool
  description = "Enable or disable automatic HTTPS redirection for this route."
}

variable "route_site1_qs_caching_behavior" {
  type        = string
  description = "Query string caching behavior for the route (e.g., IgnoreQueryString, UseQueryString)."
}

variable "route_site1_compression_enabled" {
  type        = bool
  description = "Enable or disable content compression for responses on this route."
}

variable "route_site1_content_types_to_compress" {
  type        = list(string)
  description = "List of content types that should be compressed when compression is enabled."
}

variable "route_site1_link_to_default_domain" {
  type        = bool
  description = "When true, links are rewritten to use the default Front Door domain."
}

variable "route_site1_cache_enabled" {
  type        = bool
  description = "Enable or disable the cache block for site1 route. When false, no cache configuration will be created."
}

variable "route_site1_origin_path" {
  type        = string
  description = "The origin path to use when forwarding requests to the origin. This value is appended to the origin host name when making requests to the origin."
}

variable "waf_policy_name" {
  type        = string
  description = "Name of the WAF (Web Application Firewall) policy to attach to Front Door."
}

variable "waf_enabled" {
  type        = bool
  description = "Enable or disable WAF protection for the Front Door."
}

variable "waf_mode" {
  type        = string
  description = "WAF mode (Prevention or Detection)."
}

variable "waf_managed_rule_drs_version" {
  type        = string
  description = "Version of the managed rule set for DDoS/DRS rules."
}

variable "waf_bot_rule_version" {
  type        = string
  description = "Version of the bot mitigation rules to use."
}

variable "waf_custom_rule_name" {
  type        = string
  description = "Name of a custom WAF rule to apply."
}

variable "waf_custom_rule_priority" {
  type        = number
  description = "Priority for the custom WAF rule (lower number = higher priority)."
}

variable "waf_custom_rule_enabled" {
  type        = bool
  description = "Whether the custom WAF rule is enabled."
}

variable "waf_custom_rule_action" {
  type        = string
  description = "Action for the custom WAF rule (Allow, Block, Log)."
}

variable "waf_custom_rule_type" {
  type        = string
  description = "Type of match for the custom WAF rule (MatchRule or RateLimitRule)."
}

variable "waf_custom_rule_match_variable" {
  type        = string
  description = "Variable to match in the custom WAF rule (e.g., RequestHeader, RequestBody)."
}

variable "waf_custom_rule_operator" {
  type        = string
  description = "Operator used for matching in the custom WAF rule (e.g., Equals, Contains)."
}

variable "waf_custom_rule_match_values" {
  type        = list(string)
  description = "Values to match against in the custom WAF rule."
}

variable "waf_custom_rule_transforms" {
  type        = list(string)
  description = "Transforms to apply to the matched value before evaluation (e.g., Lowercase)."
}

variable "waf_block_status_code" {
  type        = number
  description = "HTTP status code returned when the WAF blocks a request."
}

variable "waf_block_body_html" {
  type        = string
  description = "HTML body returned to clients when a request is blocked by WAF."
}

variable "security_policy_name" {
  type        = string
  description = "Name for any security policy resources to create or associate."
}

variable "diagnostic_setting_name" {
  type        = string
  description = "Name to use for diagnostic settings on Front Door resources."
}

variable "diagnostic_enabled_logs" {
  type        = list(string)
  description = "List of log categories to enable for diagnostic settings (for example: [\"FrontDoorAccessLog\"])."
}

variable "diagnostic_metric_categories" {
  type        = list(string)
  description = "List of metric categories to enable for diagnostic settings."
}

variable "law_name" {
  type        = string
  description = "Name of the Log Analytics workspace to create or use."
}

variable "law_sku" {
  type        = string
  description = "SKU for the Log Analytics workspace (for example: PerGB2018)."
}

variable "law_retention_in_days" {
  type        = number
  description = "Data retention in days for the Log Analytics workspace."
}

variable "law_tags" {
  type        = map(string)
  description = "Tags to apply to the Log Analytics workspace resource."
}

variable "azure_subscription_id" {
  type        = string
  default     = null
  description = "Subscription ID to target. If null, the provider's default subscription is used."
}

# Site2 resources (mirrors Site1)
variable "site2_eastus2_storage_account_name" {
  type        = string
  description = "Storage account name for site2 in EastUS2."
}
variable "site2_eastus2_location" {
  type        = string
  description = "Azure region for site2 EastUS2 storage account."
}
variable "site2_centralus_storage_account_name" {
  type        = string
  description = "Storage account name for site2 in CentralUS."
}
variable "site2_centralus_location" {
  type        = string
  description = "Azure region for site2 CentralUS storage account."
}

variable "site2_origin_group_name" {
  type        = string
  description = "Front Door origin group name for site2."
}
variable "site2_session_affinity_enabled" {
  type        = bool
  description = "Session affinity for site2 origin group."
}
variable "site2_lb_sample_size" {
  type        = number
  description = "LB sample size for site2 origin group."
}
variable "site2_lb_successful_samples_required" {
  type        = number
  description = "Successful samples required for site2 origin group."
}
variable "site2_health_probe_path" {
  type        = string
  description = "Health probe path for site2."
}
variable "site2_health_probe_protocol" {
  type        = string
  description = "Health probe protocol for site2."
}
variable "site2_health_probe_interval" {
  type        = number
  description = "Health probe interval for site2."
}
variable "site2_health_probe_request_type" {
  type        = string
  description = "Health probe request type for site2."
}

variable "site2_eastus2_origin_name" {
  type        = string
  description = "Origin name for site2 EastUS2."
}
variable "site2_eastus2_origin_priority" {
  type        = number
  description = "Priority for site2 EastUS2 origin."
}
variable "site2_eastus2_origin_weight" {
  type        = number
  description = "Weight for site2 EastUS2 origin."
}
variable "site2_eastus2_origin_enabled" {
  type        = bool
  description = "Enable site2 EastUS2 origin."
}
variable "site2_eastus2_http_port" {
  type        = number
  description = "HTTP port for site2 EastUS2 origin."
}
variable "site2_eastus2_https_port" {
  type        = number
  description = "HTTPS port for site2 EastUS2 origin."
}
variable "site2_eastus2_cert_name_check_enabled" {
  type        = bool
  description = "Cert name check for site2 EastUS2 origin."
}

variable "site2_centralus_origin_name" {
  type        = string
  description = "Origin name for site2 CentralUS."
}
variable "site2_centralus_origin_priority" {
  type        = number
  description = "Priority for site2 CentralUS origin."
}
variable "site2_centralus_origin_weight" {
  type        = number
  description = "Weight for site2 CentralUS origin."
}
variable "site2_centralus_origin_enabled" {
  type        = bool
  description = "Enable site2 CentralUS origin."
}
variable "site2_centralus_http_port" {
  type        = number
  description = "HTTP port for site2 CentralUS origin."
}
variable "site2_centralus_https_port" {
  type        = number
  description = "HTTPS port for site2 CentralUS origin."
}
variable "site2_centralus_cert_name_check_enabled" {
  type        = bool
  description = "Cert name check for site2 CentralUS origin."
}

variable "route_site2_name" {
  type        = string
  description = "Name of the Front Door route for site2."
}
variable "route_site2_patterns_to_match" {
  type        = list(string)
  description = "Patterns for site2 route."
}
variable "route_site2_supported_protocols" {
  type        = list(string)
  description = "Supported protocols for site2 route."
}
variable "route_site2_forwarding_protocol" {
  type        = string
  description = "Forwarding protocol for site2 route."
}
variable "route_site2_https_redirect_enabled" {
  type        = bool
  description = "HTTPS redirect for site2 route."
}
variable "route_site2_qs_caching_behavior" {
  type        = string
  description = "QS caching for site2 route."
}
variable "route_site2_compression_enabled" {
  type        = bool
  description = "Compression for site2 route."
}
variable "route_site2_content_types_to_compress" {
  type        = list(string)
  description = "Content types to compress for site2 route."
}
variable "route_site2_link_to_default_domain" {
  type        = bool
  description = "Link to default domain for site2 route."
}

variable "route_site2_origin_path" {
  type        = string
  description = "The origin path to use when forwarding requests to the origin for site2. This value is appended to the origin host name when making requests to the origin."  
}