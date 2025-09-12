azure_subscription_id   = "57afdf4b-bf7a-4539-a897-9f99749221e9" # replace with your subscription ID
resource_group_name     = "rg-frontdoor-demo"
resource_group_location = "eastus2"

site1_eastus2_storage_account_name   = "demoeastus2site1"
site1_eastus2_location               = "eastus2"
site1_centralus_storage_account_name = "democentralussite1"
site1_centralus_location             = "centralus"
storage_account_tier                 = "Standard"
storage_account_replication_type     = "LRS"
storage_account_kind                 = "StorageV2"
static_website_index_document        = "index.html"
static_website_error_document        = "error_404.html"

fd_profile_name = "demo-fd-profile"
fd_sku_name     = "Premium_AzureFrontDoor"

fd_endpoint_name = "ha024demo"

site1_origin_group_name              = "site1-origin-group"
site1_session_affinity_enabled       = false
site1_lb_sample_size                 = 4
site1_lb_successful_samples_required = 3
site1_health_probe_path              = "/"
site1_health_probe_protocol          = "Https"
site1_health_probe_interval          = 60
site1_health_probe_request_type      = "HEAD"

site1_eastus2_origin_name             = "site1-eastus2-origin"
site1_eastus2_origin_priority         = 1
site1_eastus2_origin_weight           = 50
site1_eastus2_origin_enabled          = true
site1_eastus2_http_port               = 80
site1_eastus2_https_port              = 443
site1_eastus2_cert_name_check_enabled = false

site1_centralus_origin_name             = "site1-centralus-origin"
site1_centralus_origin_priority         = 1
site1_centralus_origin_weight           = 50
site1_centralus_origin_enabled          = true
site1_centralus_http_port               = 80
site1_centralus_https_port              = 443
site1_centralus_cert_name_check_enabled = false

route_site1_name                      = "route-site1"
route_site1_patterns_to_match         = ["/site1/*"]
route_site1_supported_protocols       = ["Https", "Http"]
route_site1_forwarding_protocol       = "HttpsOnly"
route_site1_https_redirect_enabled    = true
route_site1_qs_caching_behavior       = "IgnoreQueryString"
route_site1_compression_enabled       = true
route_site1_content_types_to_compress = ["text/html", "text/css", "application/javascript"]
route_site1_link_to_default_domain    = true
route_site1_origin_path               = "/"
route_site1_cache_enabled             = false

waf_policy_name                = "frontdoorwafpolicy"
waf_enabled                    = true
waf_mode                       = "Prevention"
waf_managed_rule_drs_version   = "2.1"
waf_bot_rule_version           = "1.0"
waf_custom_rule_name           = "BlockBadIPRange"
waf_custom_rule_priority       = 100
waf_custom_rule_enabled        = true
waf_custom_rule_action         = "Block"
waf_custom_rule_type           = "MatchRule"
waf_custom_rule_match_variable = "RemoteAddr"
waf_custom_rule_operator       = "IPMatch"
waf_custom_rule_match_values   = ["203.0.113.0/24"]
waf_custom_rule_transforms     = []
waf_block_status_code          = 403
waf_block_body_html            = <<-HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Blocked by Azure Front Door WAF</title>
  <style>
    :root { --bg: #fff3cd; --fg: #1f2937; --accent: #ef4444; }
    html, body { height: 100%; margin: 0; }
    body { display: grid; place-items: center; background: var(--bg); color: var(--fg); font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; }
    .card { background: white; border-radius: 16px; padding: 28px 32px; box-shadow: 0 10px 30px rgba(0,0,0,.08); max-width: 720px; border: 3px dashed var(--accent); }
    h1 { margin: 0 0 10px; font-size: 1.6rem; }
    p { margin: 0.25rem 0; line-height: 1.5; }
    .emoji { font-size: 2rem; margin-right: .5rem; }
    code { background: #f3f4f6; padding: .15rem .35rem; border-radius: 6px; }
    .footer { margin-top: 12px; font-size: .9rem; color: #6b7280; }
  </style>
</head>
<body>
  <main class="card" role="main" aria-label="Request blocked">
    <h1><span class="emoji">🧱</span> Nice try! Your request was blocked.</h1>
    <p>Azure Front Door's Web Application Firewall is feeling protective today.</p>
    <p>If you think this is a mistake, please contact the site owner and include the time and what you were doing.</p>
    <p class="footer">HTTP <code>403</code> • Served by Azure Front Door WAF</p>
  </main>
</body>
</html>
HTML

security_policy_name = "frontdoor-security"

diagnostic_setting_name      = "frontdoor-diagnostic-settings"
diagnostic_enabled_logs      = ["FrontDoorAccessLog", "FrontDoorWebApplicationFirewallLog"]
diagnostic_metric_categories = ["AllMetrics"]

law_name              = "law-frontdoor-demo"
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_tags              = { environment = "sandbox", owner = "example" }
