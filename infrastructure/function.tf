resource "azurerm_service_plan" "default" {
  name                = "${local.basename}-sap"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku_name            = "Y1"
  os_type             = "Linux"

}
# please note:
# You may see custom (~4) is set to the app's runtime version, along with a warning says “Your app is pinned to an unsupported runtime version for ‘node’. For better performance, we recommend using one of our supported versions instead: xxx.”. This is because azure function v4 runtime requires .NET6.0 but the default value is 4.0. You need to set the .netframeworkversion to v6.0 to support azure funtion v4.
# If you would like to set the function runtime version, please use functions_extension_version property, terraform will set the FUNCTIONS_EXTENSION_VERSION in app_setting block, you don't need to specify the key in app_setting block.
# If you would like to set the required number of failed requests for an instance to be deemed unhealthy and removed from the load balancer under health check feature, using health_check_eviction_time_in_min property under site_config block. Terraform will set the key WEBSITE_HEALTHCHECK_MAXPINGFAILURES
# in app_setting for you.

resource "azurerm_linux_function_app" "scrapper" {
  name                        = "${local.basename}-scrapper"
  location                    = azurerm_resource_group.default.location
  resource_group_name         = azurerm_resource_group.default.name
  service_plan_id             = azurerm_service_plan.default.id
  storage_account_name        = azurerm_storage_account.default.name
  storage_account_access_key  = azurerm_storage_account.default.primary_access_key
  https_only                  = true
  builtin_logging_enabled     = false
  functions_extension_version = "~4"
   zip_deploy_file = local_file.wheater_release.filename
  site_config {
    application_stack {
      node_version = "18"
    }
  }
  app_settings {
    WEBSITE_RUN_FROM_PACKAGE=1
  }
}

resource "azurerm_linux_function_app" "report" {
  name                        = "${local.basename}-report"
  location                    = azurerm_resource_group.default.location
  resource_group_name         = azurerm_resource_group.default.name
  service_plan_id             = azurerm_service_plan.default.id
  storage_account_name        = azurerm_storage_account.default.name
  storage_account_access_key  = azurerm_storage_account.default.primary_access_key
  https_only                  = true
  builtin_logging_enabled     = false
  functions_extension_version = "~4"
  zip_deploy_file = local_file.report_releases.filename
  site_config {
    application_stack {
      node_version = "18"
    }
  }
  app_settings {
    WEBSITE_RUN_FROM_PACKAGE=1
  }
}

data "http" "report_function" {
  url = "https://github.com/RaLazo/Azure-Synapse-Terraform/releases/download/${var.funcRelease}/report-function.zip"
}
  

data "local_file" "report_release" {
  filename = "${path.module}/report-function.zip"
  content  = "${data.http.report_function.body}"
}

data "http" "wheater_function" {
  url = "https://github.com/RaLazo/Azure-Synapse-Terraform/releases/download/${var.funcRelease}/wheater-scrapper.zip"
}

data "local_file" "wheater_release" {
  filename = "${path.module}/wheater-function.zip"
  content  = "${data.http.wheater_function.body}"
}
