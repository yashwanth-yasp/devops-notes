
```
terraform init
terraform fmt # formatting the code
terraform validate # validate the config
terraform plan # see what terraform will create 
terraform apply # apply changes
terraform apply tfplan # apply saved plan 
terraform output # show output 
terraform output web_server_public_ip # show specifict output
terraform destroy # destroy all resources
```

# Best Practices

## File Organization 

```
project/
├── main.tf           # Primary resource definitions
├── variables.tf      # Variable declarations
├── outputs.tf        # Output definitions
├── terraform.tfvars  # Variable values (don't commit sensitive data)
├── versions.tf       # Provider version constraints
└── modules/          # Custom modules
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Naming Conventions 

- Use descriptive names for resources
- Include environment in resource names
- Use underscores in resource names, hyphens in actual resource names3. State Management

## State Management 

### Use remote state for team collaboration

terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

## Security 

- Never commit sensitive data to version controlUse environment variables or secure secret management
- Use environment variables or secure secret managementImplement proper IAM policies
- Implement proper IAM policiesUse encrypted remote state
- Use encrypted remote state5. Version Pinning



