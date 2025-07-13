resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "aca" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.0.0/23"]

  # delegation {
  #   name = "appsdelegation"
  #   service_delegation {
  #     name = "Microsoft.App/environments"  # จำเป็นสำหรับ VNet-injected ACA :contentReference[oaicite:5]{index=5}
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  #   }
  # }
}
