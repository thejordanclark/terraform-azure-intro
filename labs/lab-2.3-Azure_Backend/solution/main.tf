terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-course-backend"
    container_name       = "tfstate"
    key                  = "cprime.terraform.labs.tfstate"
  }
  required_version = ">= 1.3.0"
}

provider "random" {
}

resource "random_integer" "number" {
  min     = 1
  max     = 100
}
