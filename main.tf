terraform {
  required_providers {
    aws     = { source = "hashicorp/aws" }
    azurerm = { source = "hashicorp/azurerm" }
    google  = { source = "hashicorp/google" }
    random  = { source = "hashicorp/random" }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = "multi-cloud-terraform-462716"
  region  = "us-central1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# AWS: public-read S3 bucket (intentional misconfig)
resource "aws_s3_bucket" "example" {
  bucket = "cloudsec-aws-${random_id.suffix.hex}"
# acl    = "public-read"
}

# Azure: resource group + insecure storage account
resource "azurerm_resource_group" "example" {
  name     = "cloudsec-rg"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "cloudsec${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Azure: public container (intentional misconfig)
resource "azurerm_storage_container" "public" {
  name                  = "public"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}

# GCP: public-read GCS bucket (intentional misconfig)
resource "google_storage_bucket" "example" {
  name          = "cloudsec-gcp-${random_id.suffix.hex}"
  location      = "US"
  force_destroy = true

  # grants allUsers READ access
  # predefined_acl = "publicRead"
}
