terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "75553577-ee5a-4a09-a073-8cf4f51c51e8"
  tenant_id       = "82d2b804-7e9d-4c81-9f42-09630325bf4c"
  client_id       = "09562117-5360-4e29-8ee4-d21e0808b58a"
  client_secret   = "2AW8Q~qdZYOkI7MCfRmR2C66BqEAQajrz5DCTbYp"
}