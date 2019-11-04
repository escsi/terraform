provider "azurerm" {
    subscription_id     = "YOUR SUBSCRIPTION ID"
    client_id           = "YOUR APP CLIENT ID"
    client_secret       = "YOUR APP SECRET ID"
    tenant_id           = "YOUR TENANT ID"
}
resource "azurerm_resource_group" "myTFgroup" {
    name        = "RG-Terraform"
    location    = "koreasouth"

    tags        = {
        env = "StorageDemo"
    }
  
}
resource "azurerm_storage_account" "myTFStorage" {
    name                        = "strgmytf"
    resource_group_name         = "RG-Terraform"
    location                    = "koreasouth"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        env = "StorageDemo"
    }
  
}