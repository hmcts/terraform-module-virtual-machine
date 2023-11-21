output "test-rg" {
    value = azurerm_resource_group.test.name
}

output "test-snet" {
    value = azurerm_subnet.test.id
}

output "test-tags" {
    value = module.common_tags.common_tags
}