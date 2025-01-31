# Terraform for AzureRM - Base Template

## Overview

This template provides a sample 1-sub deploy of a base Azure Infrastructure.

It supports:

- VNET deploy in Prod/Dev environments
- Windows VMs
- Associated Public IPs and NICs

More to come.

## Set-up

1) Clone the repository:

```bash
git clone https://github.com/crypto-infinity/terraform_azure_base
```

2) Modify terraform.tfvars:
    - vnet_configs: all VNETs to be created
    - subnets_configs: all subnets associated to VNETs
    - vm_configs: all VMs to be created

3) Set Subscription ID in:
    - terraform.tfvars (subscription_id)
    - terraform.tf (subscription_id)  
    - provider.tf (subscription_id) - initializes the provider

4) Create rg-iac, with a storage account inside, with a container named "tfstate".

5) Modify, in terraform.tf, storage_account_name according to the storage account name created in step 4.

6) Apply!

```bash
terraform apply
```
