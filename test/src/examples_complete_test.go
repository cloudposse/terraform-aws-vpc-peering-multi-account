package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	terraformVpcOnlyOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/vpc-only",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Targets: []string{"module.requester_vpc", "module.requester_subnets", "module.accepter_vpc", "module.accepter_subnets"},
	}

	defer func() {
		terraform.Init(t, terraformVpcOnlyOptions)
		terraform.Destroy(t, terraformVpcOnlyOptions)
	}()

	// This will run `terraform init` and `terraform apply` to create VPCs and subnets, required for the test
	terraform.InitAndApply(t, terraformVpcOnlyOptions)
	requesterVpcId := terraform.Output(t, terraformVpcOnlyOptions, "requester_vpc_id")
	acceptorVpcId := terraform.Output(t, terraformVpcOnlyOptions, "accepter_vpc_id")

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		Vars: map[string]interface{}{
			"requester_vpc_id": requesterVpcId,
			"accepter_vpc_id": acceptorVpcId,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	println(terraform.OutputAll(t, terraformOptions))

	// Run `terraform output` to get the value of an output variable
	requesterConnectionId := terraform.Output(t, terraformOptions, "requester_connection_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, requesterConnectionId, "pcx-")

	// Run `terraform output` to get the value of an output variable
	acceptorConnectionId := terraform.Output(t, terraformOptions, "accepter_connection_id")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, acceptorConnectionId, "pcx-")

	// Run `terraform output` to get the value of an output variable
	acceptorAcceptStatus := terraform.Output(t, terraformOptions, "accepter_accept_status")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "active", acceptorAcceptStatus)

	// Run `terraform output` to get the value of an output variable
	requesterAcceptStatus := terraform.Output(t, terraformOptions, "requester_accept_status")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, "pending-acceptance", requesterAcceptStatus)
}
