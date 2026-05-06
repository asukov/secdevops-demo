# Intentionally misconfigured for demo
resource "azurerm_storage_account" "demo" {
  name                     = "demostorage"
  resource_group_name      = "demo-rg"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # BAD: Public access enabled - Checkov should catch this
  allow_nested_items_to_be_public = false

  # BAD: HTTPS not enforced
  enable_https_traffic_only = true 
}

# BAD: SSH open to world - Checkov should catch this
resource "azurerm_network_security_rule" "bad_ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = "demo-rg"
  network_security_group_name = "demo-nsg"
}
