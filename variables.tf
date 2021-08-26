variable "resource_location" {
  description = "Location of resources"
  type        = list(string)
  default =  "UK South"
  
}

variable "resource_group" {
  description = "Name of resource group"
  type        = string
  default     = "bupa-migrate-rg"
}