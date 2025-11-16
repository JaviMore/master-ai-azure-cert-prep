output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage.name
}
output "blob_container_name" {
  description = "The name of the blob container"
  value       = azurerm_storage_container.container.name
}

output "file_share_name" {
  description = "The name of the file share"
  value       = azurerm_storage_share.share.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg_budget.name
}