# Multi-Cloud Terraform Security Checks

Provision minimal AWS & Azure resources via Terraform, then scan for insecure configurations using **tfsec** and **Checkov**.


Description

This hands-on demo shows how to:

1. Use **Terraform** to provision:
   - A public-read S3 bucket in AWS  
   - A Storage Account + public container in Azure  
2. Run **tfsec** and **Checkov** to catch:
   - Publicly-readable buckets/containers  
   - Weak TLS settings  
3. Clean up to stay within free-tier limits.



 Prerequisites

- **AWS** account (Free Tier)  
- **Azure** account (Free Tier)  
- **Terraform** v1.x installed  
- **AWS CLI** & **Azure CLI** installed & authenticated  
- **tfsec** & **Checkov** installed  
