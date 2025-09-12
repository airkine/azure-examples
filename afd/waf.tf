locals {
  default_waf_block_html = <<-HTML
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
}

# WAF Policy for Front Door
resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                = var.waf_policy_name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = azurerm_cdn_frontdoor_profile.fd_profile.sku_name # must match Front Door SKU (Standard)
  enabled             = var.waf_enabled
  mode                = var.waf_mode

  custom_block_response_status_code = var.waf_block_status_code
  custom_block_response_body        = base64encode(coalesce(var.waf_block_body_html, local.default_waf_block_html))

  # Managed Default Rule Set (e.g., DRS 2.1)
  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = var.waf_managed_rule_drs_version
    action  = "Block"
  }
  # Managed Bot Protection rules
  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = var.waf_bot_rule_version
    action  = "Block"
  }

  # Custom rule example: Block a specific IP range (rate limit example)
  custom_rule {
    name     = var.waf_custom_rule_name
    priority = var.waf_custom_rule_priority
    enabled  = var.waf_custom_rule_enabled
    action   = var.waf_custom_rule_action
    type     = var.waf_custom_rule_type
    match_condition {
      match_variable = var.waf_custom_rule_match_variable
      operator       = var.waf_custom_rule_operator
      match_values   = var.waf_custom_rule_match_values
      transforms     = var.waf_custom_rule_transforms
    }
  }
}

# Link WAF policy to Front Door (Security Policy)
resource "azurerm_cdn_frontdoor_security_policy" "fd_security" {
  name                     = var.security_policy_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id
      association {
        patterns_to_match = ["/*"] # apply WAF on all routes
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
        }
      }
    }
  }
}
