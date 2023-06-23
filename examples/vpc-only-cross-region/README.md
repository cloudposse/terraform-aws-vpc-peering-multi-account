## echo example/vpc-only-cross-region

### configure 2 vpcs in the different aws region.

- Provisions a requester vpc in us-east-2 and a accepter vpc in us-west-2 region.
    ```
    # cd example/vpc-only-cross-region
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform apply -var-file=fixtures.us-east-2.tfvars
    ```

- Destroy requester and accepter vpcs.
    ```
    # cd ../vpc-only-cross-region
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.tfvars
    ```