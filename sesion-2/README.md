# Azure Terraform Infrastructure

This Terraform configuration sets up Azure resources including a resource group, budget, storage account with blob container and file share.

## Prerequisites

- **Terraform**: Version ~1.13.4 or compatible
- **Azure CLI**: Installed and authenticated to your Azure subscription
- **Azure Subscription**: You need an active Azure subscription

## Setup Instructions

### 1. Configure Subscription ID

Edit the `versions.tf` file and replace the `subscription_id` with your actual Azure subscription ID:

```hcl
provider "azurerm" {
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "your-subscription-id-here"
}
```

You can find your subscription ID by running:
```bash
az account show --query id -o tsv
```

### 2. Initialize Terraform

Run the following command to initialize the Terraform working directory:

```bash
terraform init
```

This will download the necessary provider plugins and set up the backend.

### 3. Plan the Deployment

Review the changes that Terraform will make:

```bash
terraform plan
```

### 4. Apply the Configuration

Deploy the infrastructure:

```bash
terraform apply
```

Confirm the deployment by typing `yes` when prompted.

After deployment, you can connect to the file share from your local machine using the storage account name and access key. The outputs will provide the necessary connection details.

### 5. Clean Up (Optional)

To destroy the created resources:

```bash
terraform destroy
```

## Resources Created

- Resource Group
- Consumption Budget for the resource group
- Storage Account with random suffix
- Blob Container
- File Share (50 GB quota)

## Variables

You can customize the deployment by modifying the variables in `variables.tf`:

- `resource_group_name`: Name of the resource group
- `location`: Azure region (default: North Europe)
- `budget_amount`: Budget amount in your currency
- `contact_email`: Email for budget notifications
- `storage_account_name`: Base name for storage account
- `container_name`: Name of the blob container
- `share_name`: Name of the file share

## Notes

- The storage account name includes a random suffix to ensure uniqueness.
- The budget is set up with a monthly time grain and 80% threshold notification.