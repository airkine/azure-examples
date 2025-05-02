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

## New Features and Resources

This project now includes additional resources and configurations for enhanced backup and data protection:

### Resources Added

1. **Blob Backup Policy**:
   - Configures a backup policy for Azure Blob Storage.
   - Includes daily backups with a retention period of 30 days.

2. **Backup Vault**:
   - A centralized vault for managing backup policies and instances.

3. **Role Assignments**:
   - Assigns roles such as `Storage Blob Data Contributor` and `Backup Reader` to ensure proper access control for backup operations.

4. **Backup Instances**:
   - Creates backup instances for both disk and blob storage.

5. **Storage Container for Backups**:
   - A dedicated container for storing blob backups.

### Updated Instructions

1. **Enable Backup Features**:
   - Set the `enable_backup` and `enable_blob_backup` variables to `true` in `variables.tf` to deploy backup-related resources.

2. **Deploy Backup Policies**:
   - Ensure the `azurerm_data_protection_backup_policy_blob_storage` and `azapi_resource` configurations are properly set up in `main.tf`.

3. **Role Assignments**:
   - Verify that the required role assignments are created to grant necessary permissions for backup operations.

4. **View Backup Configurations**:
   - After deployment, review the backup policies and instances in the Azure portal under the Backup Vault resource.

### Notes

- The `schema_validation_enabled` flag is set to `false` for certain resources to bypass schema validation issues.
- Ensure that the `objectType` property is correctly defined in the `azapi_resource` configurations.

Refer to the `main.tf` file for detailed configurations of these resources.

## Notes

- Ensure that the variables in `variables.tf` are set according to your environment before running the Terraform commands.
- Review the `outputs.tf` file to understand what information will be available after deployment.

## Cleanup

To remove the resources created by this configuration, run:
```bash
terraform destroy
``` 

This will delete all resources defined in the Terraform configuration.