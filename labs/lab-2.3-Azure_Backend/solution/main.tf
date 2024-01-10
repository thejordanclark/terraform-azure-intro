terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  cloud {
    organization = "ABC-Labs"
    workspaces {
      name = "labs-XX"
    }
  }
  required_version = ">= 1.3.0"
}

provider "random" {
}

resource "random_integer" "number" {
  min     = 1
  max     = 100
}
