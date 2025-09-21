// Create a custom domain on the Front Door endpoint for afd.autoaaron.xyz
resource "azurerm_cdn_frontdoor_custom_domain" "afd_custom_domain" {
  name                     = "afd-autoaaron-xyz"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  host_name                = "afd.autoaaron.xyz"

  # Minimal TLS block required by the provider. Using managed certificate.
  tls {
    certificate_type = "ManagedCertificate"
  }
}

// Routes now reference the custom domain directly via
// `cdn_frontdoor_custom_domain_ids`, so no explicit association resource is
// required. Keep the custom domain resource and DNS records; DNS validation
// (`_dnsauth.afd`) will allow Front Door to validate and serve the hostname
// once propagated.

// Create DNS CNAME record pointing afd.autoaaron.xyz -> <endpoint>.azurefd.net
// Assumes the DNS zone for autoaaron.xyz is managed in the subscription and
// its resource group is provided via variables `dns_zone_name` and `dns_resource_group_name`.
resource "azurerm_dns_cname_record" "afd_cname" {
  name                = "afd"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  record              = "${azurerm_cdn_frontdoor_endpoint.fd_endpoint.name}.azurefd.net"
}

// TXT record for Front Door dnsauth validation: _dnsauth.afd.autoaaron.xyz
resource "azurerm_dns_txt_record" "afd_dnsauth" {
  name                = "_dnsauth.afd"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  record {
    value = azurerm_cdn_frontdoor_custom_domain.afd_custom_domain.validation_token
  }
}
