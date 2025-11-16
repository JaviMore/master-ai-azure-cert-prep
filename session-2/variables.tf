variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-budget-storage"
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "North Europe"
}

variable "budget_amount" {
  description = "The amount for the budget."
  type        = number
  default     = 10
}

variable "contact_email" {
  description = "The email to contact on budget threshold notification"
  type        = string
  default     = "some-email@somedomain.com"
}


variable "start_date" {
  description = "The start date for the budget in YYYY-MM-DDTHH:MM:SSZ format."
  type        = string
  default     = "2025-10-01T00:00:00Z"

}

variable "end_date" {
  description = "The end_date for the budget in  YYYY-MM-DDTHH:MM:SSZ00:00 format."
  type        = string
  default     = "2027-10-01T00:00:00Z"

}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  default     = "storageaccount"
}

variable "container_name" {
  description = "The name of the blob container."
  type        = string
  default     = "wonderfulcontainer"
}

variable "share_name" {
  description = "The name of the file share."
  type        = string
  default     = "wonderfullfileshare"
}