resource "azurerm_container_app_environment" "env" {
  name                       = local.env_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  infrastructure_subnet_id   = azurerm_subnet.aca.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # ค่าเริ่มต้นตอนนี้เป็น workload-profiles v2 (มี Consumption profile อยู่แล้ว) :contentReference[oaicite:6]{index=6}
}


resource "azurerm_container_app" "redis" {
  name                         = local.app_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 6379
    transport        = "tcp"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  secret {
    name  = "redis-user"
    value = var.redis_user
  }
  secret {
    name  = "redis-pass"
    value = var.redis_pass
  }

  template {
    max_replicas = 1
    min_replicas = 0

    container {
      name   = "redis"
      image  = "redis:7"
      cpu    = "0.25"
      memory = "0.5Gi"


      env {
        name        = "REDIS_USER"
        secret_name = "redis-user"
      }
      env {
        name        = "REDIS_PASS"
        secret_name = "redis-pass"
      }

      # --- command override --- :contentReference[oaicite:7]{index=7}
      # command = ["/bin/sh"]
      # args = [
      #   "-c",
      #   "printf 'user $${REDIS_USER} on >$${REDIS_PASS} ~* +@all\\nuser default off' >/tmp/users.acl && redis-server --aclfile /tmp/users.acl --port 6379 --save \"\" --appendonly no"
      # ]
    }

    tcp_scale_rule {
      name                = "tcp"
      concurrent_requests = 50 # same value you used before
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image # เผื่ออัปเดตผ่าน az CLI ใน CI/CD อื่น
    ]
  }
}
