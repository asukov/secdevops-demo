resource "azurerm_storage_account" "demo" {
  name                     = "demostorage"
  resource_group_name      = "demo-rg"
  location                 = "westeurope"
  account_tier             = "Standard"

  # CKV_AZURE_206: Use geo-redundant replication
  account_replication_type = "GRS"

  # CKV2_AZURE_40: Disable Shared Key authorization
  shared_access_key_enabled = false

  # CKV_AZURE_59: Disable public access
  allow_nested_items_to_be_public = false

  # CKV_AZURE_44: Enforce latest TLS
  min_tls_version = "TLS1_2"

  # CKV_AZURE_44: HTTPS only
  https_traffic_only_enabled = true

  # CKV2_AZURE_38: Enable soft delete for blobs
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  # CKV2_AZURE_41: SAS expiration policy
  sas_policy {
    expiration_period = "00.01:00:00"
    expiration_action = "Log"
  }

  # CKV_AZURE_33: Enable queue logging
  queue_properties {
    logging {
      delete                = true
      read                  = true
      write                 = true
      version               = "1.0"
      retention_policy_days = 7
    }
  }
}

# CKV2_AZURE_1: Customer Managed Key for encryption
resource "azurerm_storage_account_customer_managed_key" "demo" {
  storage_account_id = azurerm_storage_account.demo.id
  key_vault_id       = var.key_vault_id
  key_name           = var.key_name
}

# CKV_AZURE_9: SSH restricted to internal network only
resource "azurerm_network_security_rule" "good_ssh" {
  name                        = "allow-ssh-restricted"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = "demo-rg"
  network_security_group_name = "demo-nsg"
}

variable "key_vault_id" {}
variable "key_name" {}
