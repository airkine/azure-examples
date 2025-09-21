output "fd_endpoint_host_name" {
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
  description = "Front Door endpoint host name (azurefd.net)"
}

output "fd_endpoint_id" {
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  description = "Front Door endpoint resource id"
}

output "afd_custom_domain_id" {
  value       = azurerm_cdn_frontdoor_custom_domain.afd_custom_domain.id
  description = "Custom domain resource id for afd.autoaaron.xyz"
}

output "afd_custom_domain_validation_token" {
  value       = azurerm_cdn_frontdoor_custom_domain.afd_custom_domain.validation_token
  description = <<-EOT
  Validation token returned by Front Door for dnsauth validation (create TXT with this value at _dnsauth.afd).
  Note: This value may be empty until the custom domain resource exists.
  EOT
}
