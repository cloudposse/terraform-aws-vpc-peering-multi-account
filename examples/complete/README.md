## echo example/complete

### configure vpc peering between 2 vpcs in the same aws region.

- Provisions a requester vpc and a accepter vpc in us-east-2 region.
    ```
    # cd example/vpc-only
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform apply -var-file=fixtures.us-east-2.tfvars
    ```

- Provisions a vpc peer connection between the requester vpc and accepter vpc 
  created in the above step.
    ```
    # cd ../complete
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform apply -var-file=fixtures.us-east-2.tfvars
    ```

- Destroy vpc peering connections.
    ```
    # cd ../complete
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.tfvars
    ```
  
- Destroy requester and accepter vpcs.
    ```
    # cd ../vpc-only
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.tfvars
    ```

### configure vpc peering between 2 vpcs in the different aws region.

- Provisions a requester vpc in us-east-2 and a accepter vpc in us-west-2 region.
    ```
    # cd example/vpc-only-cross-region
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform apply -var-file=fixtures.us-east-2.tfvars
    ```

- Provisions a vpc peer connection between the requester vpc and accepter vpc
  created in the above step.
    ```
    # cd ../complete
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.cross-region.tfvars
    # terraform apply -var-file=fixtures.us-east-2.cross-region.tfvars
    ```

- Destroy vpc peering connections.
    ```
    # cd ../complete
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.cross-region.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.cross-region.tfvars
    ```

- Destroy requester and accepter vpcs.
    ```
    # cd ../vpc-only-cross-region
    # terraform init
    # terraform plan -var-file=fixtures.us-east-2.tfvars
    # terraform destroy -var-file=fixtures.us-east-2.tfvars
    ```