provider "azurerm" {
    subscription_id     = "3e5f0f22-1d63-42b6-8076-db5fd00f1b0b"
    client_id           = "37a5bdbb-8202-4d4f-9c33-7b5481d18638"
    client_secret       = "0024b261-fc4d-4d72-83f7-426db8f2f2a6"
    tenant_id           = "8c653007-514e-4e25-8ae1-6c9bf91116f7"
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