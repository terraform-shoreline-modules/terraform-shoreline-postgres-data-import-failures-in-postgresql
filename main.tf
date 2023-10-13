terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "data_import_failures_in_postgresql" {
  source    = "./modules/data_import_failures_in_postgresql"

  providers = {
    shoreline = shoreline
  }
}