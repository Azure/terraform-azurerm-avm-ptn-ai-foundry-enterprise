locals {
  force_update_tag_value = formatdate("YYYY-MM-DD'T'HH:MM:SSZ", timestamp())
  tenant_id              = data.azurerm_client_config.current.tenant_id
  
}


resource "null_resource" "update_network_acl" {
  triggers = {
    always_run = timestamp() // Ensures the script runs upon each apply
  }

  provisioner "local-exec" {
    command = <<EOT
      az storage account network-rule add --account-name ${azurerm_storage_account.ml_storage.name } --resource-group ${  data.azurerm_resource_group.ai_resource_group.name} --resource-id ${azapi_resource.ai_hub.id} --tenant-id ${local.tenant_id}
    EOT
  }

  depends_on = [
   azapi_resource.ai_hub
  ]
}