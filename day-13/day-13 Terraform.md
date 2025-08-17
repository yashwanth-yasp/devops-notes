
# Terraform 

Terraform is an Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage infrastructure using declarative configuration files. Instead of manually creating resources through web consoles or command-line tools, you describe your desired infrastructure state in code.

So basically building the whole infrastructure required to run your application in the form of code instead of manually going to aws and clicking buttons

- Key Benifits
  - Declarative
  - Version Control 
  - Reproducible 
  - Multi-cloud (supports over 2000+ providers like aws and azure)

- Providers are plugins that Terraform uses to interact with cloud platforms, SaaS providers, and APIs. They translate Terraform configurations into API calls.Provider Configuration

```
# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# Google Cloud Provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Kubernetes Provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

- Data sources allow you to fetch information from existing infrastructure:# Fetch existing VPC
- Resources are the most important element in Terraform. They describe infrastructure objects like virtual machines, networks, DNS records, etc.Basic Resource Syntax
- Checkout terraform folder for codes [ec2.tf](/terraform/sample_ec2.tf) [providers.tf](/terraform/sample_providers.tf)
- Resource dependencies indicate if the resource depends on any resource which needs to be up while the construction of this one [resource_dependencies.tf](/terraform/resource_dependencies.tf)
- Resource meta arguments are arguments that can be used in the resource to control it's behaviour, for example, to tell terraform how many instances to create and what the names of all those instances must be. [resource_meta_arguments.tf](/terraform/resource_meta_arguments.tf)
- There is a complete terraform example here - [terraform-example](/terraform/simple_complete_tf_example/main.tf)
- Do know that the variables in terraform.tfvars takes precedence over variables.tf
- terraform.tfvars is basically saying these values must override the values given in the variables.tf file 
