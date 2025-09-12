# Resource Group (common for all resources)
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Storage account in East US 2
resource "azurerm_storage_account" "site1_eastus2" {
  name                     = var.site1_eastus2_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.site1_eastus2_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

# Enable static website on the storage account (index and error pages)
resource "azurerm_storage_account_static_website" "site1_eastus2_web" {
  storage_account_id = azurerm_storage_account.site1_eastus2.id
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_document
}
# (Repeat the above two resources for Central US, e.g., site1_centralus)
resource "azurerm_storage_account" "site1_centralus" {
  name                     = var.site1_centralus_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.site1_centralus_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_storage_account_static_website" "site1_centralus_web" {
  storage_account_id = azurerm_storage_account.site1_centralus.id
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_document
}

# Publish content to the static website ($web) container for East US 2
resource "azurerm_storage_blob" "site1_eastus2_index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.site1_eastus2.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Site1 East US 2</title>
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; background: #e6f2ff; }
      code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
      .card { border: 1px solid #eee; padding: 1rem 1.25rem; border-radius: 8px; max-width: 820px; }
      h1 { margin-top: 0; }
      dt { font-weight: 600; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Azure Static Website - East US 2</h1>
      <p>This page is served from the <strong>$web</strong> container of an Azure Storage Account and delivered through Azure Front Door.</p>
      <h2>Storage Account</h2>
      <dl>
        <dt>Name</dt>
        <dd><code>${azurerm_storage_account.site1_eastus2.name}</code></dd>
        <dt>Location</dt>
        <dd><code>${azurerm_storage_account.site1_eastus2.location}</code></dd>
        <dt>Static Website Endpoint</dt>
        <dd><code>${azurerm_storage_account.site1_eastus2.primary_web_endpoint}</code></dd>
      </dl>
      <h2>Azure Front Door</h2>
      <dl>
        <dt>Profile</dt>
        <dd><code>${azurerm_cdn_frontdoor_profile.fd_profile.name}</code></dd>
        <dt>Endpoint</dt>
        <dd><code>${azurerm_cdn_frontdoor_endpoint.fd_endpoint.name}.azurefd.net</code></dd>
        <dt>Origin Group</dt>
        <dd><code>${azurerm_cdn_frontdoor_origin_group.site1_origin_group.name}</code></dd>
        <dt>Route</dt>
        <dd><code>${azurerm_cdn_frontdoor_route.route_site1.name}</code> matching <code>${join(", ", azurerm_cdn_frontdoor_route.route_site1.patterns_to_match)}</code></dd>
      </dl>
    </div>
  </body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site1_eastus2_web]
}

resource "azurerm_storage_blob" "site1_eastus2_404" {
  name                   = "error_404.html"
  storage_account_name   = azurerm_storage_account.site1_eastus2.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>404 - Not Found</title><style>body { background: #e6f2ff; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; }</style></head>
  <body><h1>404 - Not Found</h1><p>Resource not found on East US 2 site.</p></body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site1_eastus2_web]
}

# Publish content to the static website ($web) container for Central US
resource "azurerm_storage_blob" "site1_centralus_index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.site1_centralus.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Site1 Central US</title>
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; background: #e8f5e9; }
      code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
      .card { border: 1px solid #eee; padding: 1rem 1.25rem; border-radius: 8px; max-width: 820px; }
      h1 { margin-top: 0; }
      dt { font-weight: 600; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Azure Static Website - Central US</h1>
      <p>This page is served from the <strong>$web</strong> container of an Azure Storage Account and delivered through Azure Front Door.</p>
      <h2>Storage Account</h2>
      <dl>
        <dt>Name</dt>
        <dd><code>${azurerm_storage_account.site1_centralus.name}</code></dd>
        <dt>Location</dt>
        <dd><code>${azurerm_storage_account.site1_centralus.location}</code></dd>
        <dt>Static Website Endpoint</dt>
        <dd><code>${azurerm_storage_account.site1_centralus.primary_web_endpoint}</code></dd>
      </dl>
      <h2>Azure Front Door</h2>
      <dl>
        <dt>Profile</dt>
        <dd><code>${azurerm_cdn_frontdoor_profile.fd_profile.name}</code></dd>
        <dt>Endpoint</dt>
        <dd><code>${azurerm_cdn_frontdoor_endpoint.fd_endpoint.name}.azurefd.net</code></dd>
        <dt>Origin Group</dt>
        <dd><code>${azurerm_cdn_frontdoor_origin_group.site1_origin_group.name}</code></dd>
        <dt>Route</dt>
        <dd><code>${azurerm_cdn_frontdoor_route.route_site1.name}</code> matching <code>${join(", ", azurerm_cdn_frontdoor_route.route_site1.patterns_to_match)}</code></dd>
      </dl>
    </div>
  </body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site1_centralus_web]
}

resource "azurerm_storage_blob" "site1_centralus_404" {
  name                   = "error_404.html"
  storage_account_name   = azurerm_storage_account.site1_centralus.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>404 - Not Found</title><style>body { background: #e8f5e9; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; }</style></head>
  <body><h1>404 - Not Found</h1><p>Resource not found on Central US site.</p></body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site1_centralus_web]
}

# Site2 storage accounts and static websites
resource "azurerm_storage_account" "site2_eastus2" {
  name                     = var.site2_eastus2_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.site2_eastus2_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_storage_account_static_website" "site2_eastus2_web" {
  storage_account_id = azurerm_storage_account.site2_eastus2.id
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_document
}

resource "azurerm_storage_account" "site2_centralus" {
  name                     = var.site2_centralus_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.site2_centralus_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_storage_account_static_website" "site2_centralus_web" {
  storage_account_id = azurerm_storage_account.site2_centralus.id
  index_document     = var.static_website_index_document
  error_404_document = var.static_website_error_document
}

resource "azurerm_storage_blob" "site2_eastus2_index" {
  name                   = var.static_website_index_document
  storage_account_name   = azurerm_storage_account.site2_eastus2.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Site2 East US 2</title>
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; background: #fff0f6; }
      code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
      .card { border: 1px solid #eee; padding: 1rem 1.25rem; border-radius: 8px; max-width: 820px; }
      h1 { margin-top: 0; }
      dt { font-weight: 600; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Azure Static Website - Site2 East US 2</h1>
      <p>This page is served from the <strong>$web</strong> container of an Azure Storage Account and delivered through Azure Front Door.</p>
      <h2>Storage Account</h2>
      <dl>
        <dt>Name</dt>
        <dd><code>${azurerm_storage_account.site2_eastus2.name}</code></dd>
        <dt>Location</dt>
        <dd><code>${azurerm_storage_account.site2_eastus2.location}</code></dd>
        <dt>Static Website Endpoint</dt>
        <dd><code>${azurerm_storage_account.site2_eastus2.primary_web_endpoint}</code></dd>
      </dl>
    </div>
  </body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site2_eastus2_web]
}

resource "azurerm_storage_blob" "site2_eastus2_404" {
  name                   = var.static_website_error_document
  storage_account_name   = azurerm_storage_account.site2_eastus2.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>404 - Not Found</title><style>body { background: #fff0f6; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; }</style></head>
  <body><h1>404 - Not Found</h1><p>Resource not found on Site2 East US 2 site.</p></body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site2_eastus2_web]
}

resource "azurerm_storage_blob" "site2_centralus_index" {
  name                   = var.static_website_index_document
  storage_account_name   = azurerm_storage_account.site2_centralus.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Site2 Central US</title>
    <style>
      body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; background: #f0f5ff; }
      code { background: #f5f5f5; padding: 0.2rem 0.4rem; border-radius: 4px; }
      .card { border: 1px solid #eee; padding: 1rem 1.25rem; border-radius: 8px; max-width: 820px; }
      h1 { margin-top: 0; }
      dt { font-weight: 600; }
    </style>
  </head>
  <body>
    <div class="card">
      <h1>Azure Static Website - Site2 Central US</h1>
      <p>This page is served from the <strong>$web</strong> container of an Azure Storage Account and delivered through Azure Front Door.</p>
      <h2>Storage Account</h2>
      <dl>
        <dt>Name</dt>
        <dd><code>${azurerm_storage_account.site2_centralus.name}</code></dd>
        <dt>Location</dt>
        <dd><code>${azurerm_storage_account.site2_centralus.location}</code></dd>
        <dt>Static Website Endpoint</dt>
        <dd><code>${azurerm_storage_account.site2_centralus.primary_web_endpoint}</code></dd>
      </dl>
    </div>
  </body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site2_centralus_web]
}

resource "azurerm_storage_blob" "site2_centralus_404" {
  name                   = var.static_website_error_document
  storage_account_name   = azurerm_storage_account.site2_centralus.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-EOT
  <!doctype html>
  <html lang="en">
  <head><meta charset="utf-8" /><title>404 - Not Found</title><style>body { background: #f0f5ff; font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 2rem; }</style></head>
  <body><h1>404 - Not Found</h1><p>Resource not found on Site2 Central US site.</p></body>
  </html>
  EOT

  depends_on = [azurerm_storage_account_static_website.site2_centralus_web]
}
