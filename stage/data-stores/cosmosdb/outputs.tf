output "address" {
  value = azurerm_mysql_flexible_server.example.fqdn
  description = "Connect to the database at this endpoint"
}
