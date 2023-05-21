resource "azurerm_eventhub_namespace" "default" {
  name                = "${local.basename}-openDataEventhubNamespace"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Production"
  }
}

resource "azurerm_eventhub" "default" {
  name                = "${local.basename}-wheaterdata"
  namespace_name      = azurerm_eventhub_namespace.default.name
  resource_group_name = azurerm_resource_group.default.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "default" {
  name                = "${local.basename}-wheaterdata"
  namespace_name      = azurerm_eventhub_namespace.default.name
  eventhub_name       = azurerm_eventhub.default.name
  resource_group_name = azurerm_resource_group.default.name
  user_metadata       = "some-meta-data"
}


resource "azurerm_eventhub_authorization_rule" "listner" {
  name                = "${local.basename}-synapseAnalyiticsEventListner"
  namespace_name      = azurerm_eventhub_namespace.default.name
  eventhub_name       = azurerm_eventhub.default.name
  resource_group_name = azurerm_resource_group.default.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_authorization_rule" "sender" {
  name                = "${local.basename}-functionEventSender"
  namespace_name      = azurerm_eventhub_namespace.default.name
  eventhub_name       = azurerm_eventhub.default.name
  resource_group_name = azurerm_resource_group.default.name
  listen              = false
  send                = true
  manage              = false
}