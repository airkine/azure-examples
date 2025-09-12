# Front Door profile (Standard SKU)
resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = var.fd_profile_name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.fd_sku_name
}

# Front Door endpoint (default domain)
resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = var.fd_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

# Origin Group for Site1
resource "azurerm_cdn_frontdoor_origin_group" "site1_origin_group" {
  name                     = var.site1_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  session_affinity_enabled = var.site1_session_affinity_enabled
  load_balancing {
    sample_size                 = var.site1_lb_sample_size
    successful_samples_required = var.site1_lb_successful_samples_required
  }
  health_probe {
    path                = var.site1_health_probe_path
    protocol            = var.site1_health_probe_protocol
    interval_in_seconds = var.site1_health_probe_interval
    request_type        = var.site1_health_probe_request_type
  }
}

# Origins for Site1 in two regions
resource "azurerm_cdn_frontdoor_origin" "site1_eastus2" {
  name                           = var.site1_eastus2_origin_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.site1_origin_group.id
  host_name                      = trim(replace(azurerm_storage_account.site1_eastus2.primary_web_endpoint, "https://", ""), "/")
  origin_host_header             = trim(replace(azurerm_storage_account.site1_eastus2.primary_web_endpoint, "https://", ""), "/")
  priority                       = var.site1_eastus2_origin_priority
  weight                         = var.site1_eastus2_origin_weight
  enabled                        = var.site1_eastus2_origin_enabled
  http_port                      = var.site1_eastus2_http_port
  https_port                     = var.site1_eastus2_https_port
  certificate_name_check_enabled = false # disable since using azure *.web.core.windows cert

  depends_on = [azurerm_storage_account_static_website.site1_eastus2_web] # ensure website enabled before origin creation
}

resource "azurerm_cdn_frontdoor_origin" "site1_centralus" {
  name                           = var.site1_centralus_origin_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.site1_origin_group.id
  host_name                      = trim(replace(azurerm_storage_account.site1_centralus.primary_web_endpoint, "https://", ""), "/")
  origin_host_header             = trim(replace(azurerm_storage_account.site1_centralus.primary_web_endpoint, "https://", ""), "/")
  priority                       = var.site1_centralus_origin_priority
  weight                         = var.site1_centralus_origin_weight
  enabled                        = var.site1_centralus_origin_enabled
  http_port                      = var.site1_centralus_http_port
  https_port                     = var.site1_centralus_https_port
  certificate_name_check_enabled = var.site1_centralus_cert_name_check_enabled

  depends_on = [azurerm_storage_account_static_website.site1_centralus_web] # ensure website enabled before origin creation

}
# (Similarly, define azurerm_cdn_frontdoor_origin_group and origins for Site2)

# Route for Site1
resource "azurerm_cdn_frontdoor_route" "route_site1" {
  name                          = var.route_site1_name
  cdn_frontdoor_origin_path     = var.route_site1_origin_path
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.site1_origin_group.id
  cdn_frontdoor_origin_ids = [
    azurerm_cdn_frontdoor_origin.site1_eastus2.id,
    azurerm_cdn_frontdoor_origin.site1_centralus.id
  ]
  patterns_to_match      = var.route_site1_patterns_to_match
  link_to_default_domain = var.route_site1_link_to_default_domain
  supported_protocols    = var.route_site1_supported_protocols
  forwarding_protocol    = var.route_site1_forwarding_protocol
  https_redirect_enabled = var.route_site1_https_redirect_enabled
  dynamic "cache" {
    for_each = var.route_site1_cache_enabled ? [1] : []
    content {
      query_string_caching_behavior = var.route_site1_qs_caching_behavior
      compression_enabled           = var.route_site1_compression_enabled
      content_types_to_compress     = var.route_site1_content_types_to_compress
    }
  }
}

## Route for Site2 can be added once Site2 origins/groups exist
