
## Require

```
brew install redis
cd infra
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```