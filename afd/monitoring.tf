# Assuming we have an existing Log Analytics Workspace resource azurerm_log_analytics_workspace.law
resource "azurerm_monitor_diagnostic_setting" "fd_diagnostics" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_cdn_frontdoor_profile.fd_profile.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # Enable all Front Door/CDN diagnostic log categories allowed by the provider.
  # Common categories: FrontDoorAccessLog, FrontDoorWebApplicationFirewallLog
  dynamic "enabled_log" {
    for_each = var.diagnostic_enabled_logs
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = var.diagnostic_metric_categories
    content {
      category = enabled_metric.value
    }
  }
}


// Log Analytics workspace for Front Door diagnostics
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.law_sku

  retention_in_days = var.law_retention_in_days

  tags = var.law_tags
}
