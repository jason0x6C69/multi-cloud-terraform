terraform {
  required_providers {
    aws     = { source = "hashicorp/aws" }
    azurerm = { source = "hashicorp/azurerm" }
    random  = { source = "hashicorp/random" }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "aws"
}

provider "azurerm" {
  features {}
  alias = "azure"
  resource_provider_registrations = "none"
}

resource "random_id" "suffix" {
  byte_length = 4
}

# AWS: insecure S3 bucket
resource "aws_s3_bucket" "example" {
  provider = aws
  bucket   = "cloudsec-aws-${random_id.suffix.hex}"
  acl      = "public-read"
}

# Azure: RG + storage container
resource "azurerm_resource_group" "example" {
  provider = azurerm
  name     = "cloudsec-rg"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  provider                          = azurerm
  name                              = "cloudsec${random_id.suffix.hex}"
  resource_group_name               = azurerm_resource_group.example.name
  location                          = azurerm_resource_group.example.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  allow_nested_items_to_be_public   = true
  min_tls_version                   = "TLS1_0"
}

resource "azurerm_storage_container" "public" {
  provider              = azurerm
  name                  = "public"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "blob"
}
