## echo example/vpc-only

### configure 2 vpcs in the same aws region.

- Provisions a requester vpc and a accepter vpc in us-east-2 region.
    ```
    # cd example/vpc-only
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform apply -var-file=fixtures.us-east-2.tfvars
    ```
  
- Destroy requester and accepter vpcs.
    ```
    # cd ../vpc-only
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.tfvars
    ```