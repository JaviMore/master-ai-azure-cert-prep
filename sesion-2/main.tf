#  Create a Resource Group for the budget and function app.
resource "azurerm_resource_group" "rg_budget" {
  name     = var.resource_group_name
  location = var.location
}

#  Create a budget for the resource group.
resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "budget-for-vm-shutdown"
  resource_group_id = azurerm_resource_group.rg_budget.id
  amount            = var.budget_amount
  time_grain        = "Monthly"
  time_period {
    start_date = var.start_date
    end_date   = var.end_date
  }

  notification {
    enabled        = true
    operator       = "GreaterThan"
    threshold      = 80.0
    contact_emails = [var.contact_email]
  }

}

# Generate a random suffix for the storage account name to ensure uniqueness
resource random_integer "storage_suffix" {
  min = 10000
  max = 99999
}

# Create a Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}${random_integer.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_budget.name
  location                 = azurerm_resource_group.rg_budget.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a Blob Container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_id  = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# Create a File Share
resource "azurerm_storage_share" "share" {
  name                 = var.share_name
  storage_account_id = azurerm_storage_account.storage.id
  quota               = 50
  acl {
    id = "Everyone"
    access_policy {
      permissions = "rwdl"
    }
  }
}

