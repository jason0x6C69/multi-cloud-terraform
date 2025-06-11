---
title: "Multi-Cloud Terraform Security Checks"
---

# Multi-Cloud Terraform Security Checks

Provision minimal AWS & Azure resources via Terraform, then scan for insecure configs using **tfsec** and **Checkov**.

---

## Prerequisites

- AWS account (Free Tier)  
- Azure account (Free Tier)  
- Terraform v1.x installed  
- AWS CLI & Azure CLI installed & authenticated  
- tfsec & Checkov installed  

---

## Getting Started

### 1. Clone & Prepare
```bash
git clone https://github.com/<your-username>/multi-cloud-terraform.git
cd multi-cloud-terraform
