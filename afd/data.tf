data "azurerm_dns_zone" "this" {
    name                = var.dns_zone_name
    resource_group_name = var.dns_resource_group_name
}