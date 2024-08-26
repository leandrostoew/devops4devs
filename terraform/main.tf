terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aula_rg" {
  name     = "aula-rg"
  location = "westus"
}

resource "azurerm_kubernetes_cluster" "aula_k8s" {
  name                = var.k8s_name
  location            = azurerm_resource_group.aula_rg.location
  resource_group_name = azurerm_resource_group.aula_rg.name
  dns_prefix          = "aula-k8s"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "k9s_config" {
  content  = azurerm_kubernetes_cluster.aula_k8s.kube_admin_config_raw
  filename = "kube_config_aks.yaml"
}

variable "k8s_name" {
    description = "Nome do cluster kubernetes"
    type = string
    default = "aula-k8s"
}

variable "node_count" {
    description = "Quantidade de nodes"
    type = number
    default = 3
}