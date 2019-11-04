/*
    Azure 에서 subscription_id, client_id, client_secret, tenant_id 는 아래의 URL 을 참고
    https://docs.microsoft.com/ko-kr/azure/virtual-machines/linux/terraform-install-configure

*/

provider "azurerm" {
    subscription_id     = "YOUR SUBSCRIPTION ID"
    client_id           = "YOUR APP CLIENT ID"
    client_secret       = "YOUR APP SECRET ID"
    tenant_id           = "YOUR TENANT ID"
}
variable "myregion" {
    type = "string"
    default = "koreasouth"
  
}
resource "azurerm_resource_group" "myTFgroup" {
    name        = "RG-Terraform"
    location    = "${var.myregion}"

    tags        = {
        env = "TerraformVMDemo"
    }
  
}
resource "azurerm_virtual_network" "myTFVnet" {
    name                    = "VNET-MY-TF"
    address_space           = ["10.100.0.0/16"]
    location                = "${var.myregion}"
    resource_group_name     = "${azurerm_resource_group.myTFgroup.name}"

    tags = {
        env = "TerraformVMDemo"
    }
  
}
resource "azurerm_subnet" "myTFSubnet" {
    name                    = "SBNET-MY-TF"
    resource_group_name     = "${azurerm_resource_group.myTFgroup.name}"
    virtual_network_name    = "${azurerm_virtual_network.myTFVnet.name}"
    address_prefix          = "10.100.10.0/24"
  
}

resource "azurerm_public_ip" "myTFPubIp" {
    name                    = "PubIP-MY-TF"
    location                = "${var.myregion}"
    resource_group_name     = "${azurerm_resource_group.myTFgroup.name}"
    allocation_method       = "Dynamic"

    tags = {
        env = "TerraformVMDemo"
    }
 
}
resource "azurerm_network_security_group" "myTFSecGrp" {
    name                    = "NSG-MY-TF"
    location                = "${var.myregion}"
    resource_group_name     = "${azurerm_resource_group.myTFgroup.name}"

    security_rule {
        name                        = "SSH"
        priority                    = 1001
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "22"
        source_address_prefix       = "*"
        destination_address_prefix  = "*"
        
    }

    tags = {
        env = "TerraformVMDemo"
    }

}
resource "azurerm_network_interface" "myTFNic" {
    name                        = "NIC-MY-TF"
    location                    = "${var.myregion}"
    resource_group_name         = "${azurerm_resource_group.myTFgroup.name}"
    network_security_group_id   = "${azurerm_network_security_group.myTFSecGrp.id}"

    ip_configuration {
        name                            = "ipconfig-MY-tf"
        subnet_id                       = "${azurerm_subnet.myTFSubnet.id}"
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = "${azurerm_public_ip.myTFPubIp.id}"
    }

    tags = {
        env = "TerraformVMDemo"
    }
  
}
resource "azurerm_storage_account" "myTFStorage" {
    name                        = "strgmyTf"
    resource_group_name         = "${azurerm_resource_group.myTFgroup.name}"
    location                    = "${var.myregion}"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

    tags = {
        env = "TerraformVMDemo"
    }
  
}

resource "azurerm_virtual_machine" "myTFVM" {
    name                        = "VM-MY-TF"
    location                    = "${var.myregion}"
    resource_group_name         = "${azurerm_resource_group.myTFgroup.name}"
    network_interface_ids       = ["${azurerm_network_interface.myTFNic.id}"]
    vm_size                     = "Standard_D2s_v3"

    storage_os_disk {
        name                    = "VM-MY-TF-OsDisk"
        caching                 = "ReadWrite"
        create_option           = "FromImage"
        managed_disk_type       = "Premium_LRS"

    }

    storage_image_reference {
        publisher               = "Canonical"
        offer                   = "UbuntuServer"
        sku                     = "16.04.0-LTS"
        version                 = "latest"
        
    }

    os_profile {
        computer_name           = "gsvm"
        admin_username          = "azureuser"
        admin_password          = "P@ssw0rd123!@#"

    }

    os_profile_linux_config {
        disable_password_authentication = false

    }

    boot_diagnostics {
        enabled         = true
        storage_uri     = "${azurerm_storage_account.myTFStorage.primary_blob_endpoint}"
    }

    tags = {
        env = "TerraformVMDemo"
    }
  
}







