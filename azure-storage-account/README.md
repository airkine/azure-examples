# Azure Storage Account Terraform Project

This project sets up an Azure Storage Account using Terraform. It is organized into multiple files for better maintainability and clarity.

## Project Structure

- `main.tf`: Contains the main configuration for the Azure storage account resource.
- `variables.tf`: Defines all the input variables used in the Terraform configuration.
- `provider.tf`: Specifies the provider configuration for Azure.
- `locals.tf`: Defines local values that can be used throughout the Terraform configuration.
- `data.tf`: Used to define any data sources that the configuration might need.
- `outputs.tf`: Defines the outputs of the Terraform configuration.
  
## Prerequisites

- Terraform installed on your machine.
- An Azure account with the necessary permissions to create resources.
- Azure CLI installed and configured for authentication.

## Getting Started

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd azure-storage-account
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   To see what resources will be created, run:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   To create the resources defined in the configuration, run:
   ```bash
   terraform apply
   ```

5. **Accessing Outputs**:
   After applying, you can view the outputs defined in `outputs.tf` to get information such as the storage account endpoint.

## Notes

- Ensure that the variables in `variables.tf` are set according to your environment before running the Terraform commands.
- Review the `outputs.tf` file to understand what information will be available after deployment.

## Cleanup

To remove the resources created by this configuration, run:
```bash
terraform destroy
``` 

This will delete all resources defined in the Terraform configuration.