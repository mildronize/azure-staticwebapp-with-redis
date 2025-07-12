output "redis_fqdn" {
  value       = azurerm_container_app.redis.ingress[0].fqdn
  description = "Public FQDN of the Redis Container App"
}
