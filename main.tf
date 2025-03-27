# main.tf

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks-cluster-1" {
  name                = "proj-3-k8s"
  location            = var.rg_loc
  resource_group_name = var.rg_name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "aksnodepool"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster-1.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster-1.kube_config_raw

  sensitive = true
}


# Azure Container Registry
resource "azurerm_container_registry" "cr-1" {
  name                = "akscr1mmoore"
  resource_group_name = var.rg_name
  location            = var.rg_loc
  sku                 = "Premium"
}

# Kubernetes provider configuration to interact with the AKS cluster
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks-cluster-1.kube_config[0].host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks-cluster-1.kube_config[0].cluster_ca_certificate)
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks-cluster-1.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks-cluster-1.kube_config[0].client_key)
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx" # Ensure the Nginx pod has this label
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
