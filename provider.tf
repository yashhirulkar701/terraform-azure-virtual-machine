terraform {

  cloud {
    organization = "55-org"

    workspaces {
      name = "terraform-azure-virtual-machine"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.10.0"
    }
  }

  required_version = ">= 1.2.3"
}

provider "azurerm" {
  features {}
}
