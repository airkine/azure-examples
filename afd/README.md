# afd Terraform quick guide

This folder contains Terraform configuration for an Azure Front Door (CDN Front Door) profile, endpoint, origins, routes, WAF, and custom domain setup for `afd.autoaaron.xyz`.

Overview
--------
The configuration performs these high-level actions:
- Creates a Front Door profile and an endpoint
- Declares origin groups and origins for two sites
- Declares routes that map incoming requests to origin groups
- Declares a managed custom domain (`azurerm_cdn_frontdoor_custom_domain`) for `afd.autoaaron.xyz`
- (Optionally) Creates DNS records in Azure DNS: a CNAME (`afd`) and a `_dnsauth.afd` TXT used by Front Door for ownership validation
- Declares a WAF policy and associates it with the Front Door profile / custom domain
- **Creates maintenance pages for all static websites** - professional maintenance pages are deployed to each storage account

Maintenance Pages
-----------------
Each static website has a dedicated maintenance page (`maintenance.html`) that can be used during scheduled maintenance or outages. The maintenance pages include:

- **Professional styling** with responsive design
- **Auto-refresh capability** (every 30 seconds by default)
- **Site-specific information** including storage account details and region
- **Color-coded themes** matching each site's branding
- **Estimated duration display** for user expectations

### Accessing Maintenance Pages
To access the maintenance pages directly on each storage account:
- Site1 East US 2: `https://{site1-eastus2-storage-account}.z13.web.core.windows.net/maintenance.html`
- Site1 Central US: `https://{site1-centralus-storage-account}.z4.web.core.windows.net/maintenance.html`
- Site2 East US 2: `https://{site2-eastus2-storage-account}.z13.web.core.windows.net/maintenance.html`
- Site2 Central US: `https://{site2-centralus-storage-account}.z4.web.core.windows.net/maintenance.html`

### Maintenance Mode Configuration
Control maintenance page behavior using these variables:
- `maintenance_page_enabled` - Enable/disable maintenance page creation (default: `true`)
- `maintenance_page_refresh_interval` - Auto-refresh interval in seconds (default: `30`)
- `maintenance_expected_duration` - Expected duration text (default: `"15-30 minutes"`)
- `maintenance_message` - Custom maintenance message

Example customization in `terraform.tfvars`:
```hcl
maintenance_page_refresh_interval = 60
maintenance_expected_duration     = "1-2 hours"
maintenance_message              = "We're upgrading our infrastructure to serve you better. Thank you for your patience."
```

### Switching to Maintenance Mode
To redirect traffic to maintenance pages:
1. **Option A (Azure Portal)**: Update Azure Front Door routes to point to `maintenance.html`
2. **Option B (DNS)**: Temporarily update DNS records to point directly to storage account endpoints
3. **Option C (WAF Rules)**: Create WAF rules to redirect specific traffic to maintenance pages

**Note**: These maintenance pages are always available but require manual routing configuration to display them to users.

Two-step apply workflow (recommended)
-------------------------------------
Because Azure Front Door validation depends on DNS propagation, the recommended, reliable workflow is two-step:

1) First apply — create the custom domain and outputs
   - This will create the `azurerm_cdn_frontdoor_custom_domain` resource and (if `var.create_dns_txt_validation = true`) the TXT/CNAME records in the Azure DNS zone.
   - Run:

```bash
cd afd
terraform init
terraform apply -auto-approve
```

   - After completion, inspect the outputs:
     - `afd_custom_domain_validation_token` — if DNS is external or you chose not to let Terraform create the TXT, copy this token into `_dnsauth.afd.autoaaron.xyz` in your DNS provider.
     - `fd_endpoint_host_name` — the Front Door generated host name (e.g., `ha0xxwhatever.azurefd.net`)

2) DNS propagation and validation
   - If Terraform created the TXT record in Azure DNS (and the zone is correct), wait for DNS propagation. If DNS is external, create the TXT record manually using the token from the outputs.
   - You can verify the TXT record locally (replace `autoaaron.xyz` with your zone):

```bash
dig +short TXT _dnsauth.afd.autoaaron.xyz
```

   - Give DNS time to propagate (usually minutes; sometimes up to an hour depending on registrars/TTL). Once Front Door detects the TXT record it will validate the custom domain and issue a managed certificate.

3) Final apply (if needed)
   - If you created the TXT record manually outside Terraform, run `terraform apply` again to let Terraform reconcile state. If Terraform created the DNS records already, you likely only need to wait — Front Door will automatically validate and provision the certificate.

Troubleshooting
---------------
- Error: "the CDN FrontDoor Route(Name: \"route-site1\") is currently not associated with the CDN FrontDoor Custom Domain"
  - Don’t try to associate routes with the custom domain via a standalone `azurerm_cdn_frontdoor_custom_domain_association` while the domain is unvalidated. Create the custom domain (host_name + profile) and the required `_dnsauth` TXT first, and only add explicit association after validation if you need fine-grained route-level associations.

- DNS zone not in Azure
  - If your authoritative DNS is external, set `var.create_dns_txt_validation = false` and create the `_dnsauth.afd` TXT record manually using the output token. Terraform cannot create external DNS records for you.

- Check validation status in Azure Portal
  - Open the Front Door Profile in the Azure Portal -> Custom domains. Your domain will show a validation status. After the TXT is resolvable and Front Door verifies ownership, status will change and the managed certificate will be issued.

- Debugging token not present
  - If `azurerm_cdn_frontdoor_custom_domain.validation_token` is empty in outputs or resources, Terraform may not have created the custom domain (or provider version issues). Ensure you ran `terraform apply` and the resource exists in state. Check `terraform state show azurerm_cdn_frontdoor_custom_domain.afd_custom_domain`.

Reintroducing route-level association
-------------------------------------
If you still want explicit route-level association using `azurerm_cdn_frontdoor_custom_domain_association`, follow these steps:

1. Ensure the custom domain is validated (see steps above).
2. Confirm which routes you want associated (for example `azurerm_cdn_frontdoor_route.route_site1` and/or `route_site2`).
3. Add a `azurerm_cdn_frontdoor_custom_domain_association` resource, but only after the custom domain exists and the routes are physically associated with the profile. If Terraform previously failed creating such an association, remove the previous association resource, wait for validation, then create the association resource in a subsequent apply.

If you want, I can implement the correct reintroduction sequence for you (I will:
- add the association resource but gated behind a boolean variable (e.g., `create_custom_domain_association`) and
- optionally make it depend on a `null_resource` that waits for `validation_token` to be non-empty so it runs only after the token is present). Tell me which routes to include and whether you want the gated approach and I'll add it.

Contact / next actions
----------------------
- Tell me if you want me to:
  - Add the gated `azurerm_cdn_frontdoor_custom_domain_association` now (and which routes to associate), or
  - Implement the one-step automation to create TXT and wait for validation, or
  - Add a short helper script to poll validation status.

All changes validated with `terraform validate` after editing.
