resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  daily_quota_gb      = 0.1
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
