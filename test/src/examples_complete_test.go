package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformVpcOnlyOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
		Targets: []string{"module.requester_vpc", "module.requester_subnets", "module.accepter_vpc", "module.accepter_subnets"},
		Vars: map[string]interface{}{
			"requester_vpc_id": "vpc-XXX",
			"accepter_vpc_id": "vpc-XXX",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformVpcOnlyOptions)

	// This will run `terraform init` and `terraform apply` to create VPCs and subnets, required for the test
	terraform.InitAndApply(t, terraformVpcOnlyOptions)
	requesterVpcId := terraform.Output(t, terraformVpcOnlyOptions, "requester_vpc_id")
	acceptorVpcId := terraform.Output(t, terraformVpcOnlyOptions, "accepter_vpc_id")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
		Vars: map[string]interface{}{
			"requester_vpc_id": requesterVpcId,
			"accepter_vpc_id": acceptorVpcId,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	requesterConnectionId := terraform.Output(t, terraformOptions, "requester_connection_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, requesterConnectionId, "pcx-")

	// Run `terraform output` to get the value of an output variable
	acceptorConnectionId := terraform.Output(t, terraformOptions, "accepter_connection_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, acceptorConnectionId, "pcx-")

	// Run `terraform output` to get the value of an output variable
	requesterVpcCidr := terraform.Output(t, terraformOptions, "requester_vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.16.0.0/16", requesterVpcCidr)

	// Run `terraform output` to get the value of an output variable
	requesterPrivateSubnetCidrs := terraform.OutputList(t, terraformOptions, "requester_private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.0.0/19", "172.16.32.0/19"}, requesterPrivateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	requesterPublicSubnetCidrs := terraform.OutputList(t, terraformOptions, "requester_public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.16.96.0/19", "172.16.128.0/19"}, requesterPublicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	acceptorVpcCidr := terraform.Output(t, terraformOptions, "acceptor_vpc_cidr")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "172.32.0.0/16", acceptorVpcCidr)

	// Run `terraform output` to get the value of an output variable
	acceptorPrivateSubnetCidrs := terraform.OutputList(t, terraformOptions, "acceptor_private_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.32.0.0/19", "172.32.32.0/19"}, acceptorPrivateSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	acceptorPublicSubnetCidrs := terraform.OutputList(t, terraformOptions, "acceptor_public_subnet_cidrs")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, []string{"172.32.96.0/19", "172.32.128.0/19"}, acceptorPublicSubnetCidrs)

	// Run `terraform output` to get the value of an output variable
	acceptorAcceptStatus := terraform.Output(t, terraformOptions, "accepter_accept_status")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "active", acceptorAcceptStatus)

	// Run `terraform output` to get the value of an output variable
	requesterAcceptStatus := terraform.Output(t, terraformOptions, "requester_accept_status")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "active", requesterAcceptStatus)

}
