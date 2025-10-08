resource "azurerm_cdn_frontdoor_rule_set" "main" {
  name                      = "mainrules"
  cdn_frontdoor_profile_id  = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_rule" "maintenance" {
  name                      = "maintenance"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.main.id
  order                     = 7
  behavior_on_match         = "Stop"

  # Simple toggle: header or query flag
  conditions {
    request_header_condition {
      operator     = "Equal"
      match_values = ["on"]
      header_name  = "X-Maintenance"
      negate_condition = false
      transforms   = []
    }
  }

  actions {
    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/maintenance.html"
      preserve_unmatched_path = false
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "security_headers" {
  name                      = "securityheaders"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.main.id
  order                     = 8
  behavior_on_match         = "Continue"

  actions {
    response_header_action {
      header_action = "Append"
      header_name   = "Strict-Transport-Security"
      value         = "max-age=31536000; includeSubDomains; preload"
    }

    response_header_action {
      header_action = "Append"
      header_name   = "X-Content-Type-Options"
      value         = "nosniff"
    }

    response_header_action {
      header_action = "Append"
      header_name   = "X-Frame-Options"
      value         = "DENY"
    }

    response_header_action {
      header_action = "Append"
      header_name   = "Referrer-Policy"
      value         = "no-referrer"
    }

    response_header_action {
      header_action = "Append"
      header_name   = "Content-Security-Policy"
      value         = "default-src 'self'; object-src 'none'; frame-ancestors 'none'"
    }
  }
}
