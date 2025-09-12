NSG + ASG demo

This folder contains a small Terraform example showing how to use Network Security Groups (NSG) and Application Security Groups (ASG) to control network flows between an app tier and a database tier.

What it demonstrates
- A VNet with two subnets: `app` and `db`.
- An NSG that allows traffic from the app ASG to the db ASG on TCP/1433 and denies other inbound traffic (example only).
- Two VMs (app and db) with NICs in their respective subnets.

Quick start
1. Set your Azure credentials (via `az login` or environment variables).
2. From this folder run:

```bash
terraform init
terraform plan
terraform apply -var="admin_ssh_public_key=\"$(cat ~/.ssh/id_rsa.pub)\"" -auto-approve
```

Notes and safety
- This example is educational. The `Deny-Other-Inbound` rule is aggressive and included to demonstrate explicit deny - do not use as-is in production.
- Replace the placeholder SSH public key variable with your real public key or pass via `-var`.
- This example uses small VM SKUs and may incur some Azure costs when applied. Destroy resources after experimenting with `terraform destroy`.
