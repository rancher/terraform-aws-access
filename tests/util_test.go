package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func teardown(t *testing.T, directory string) {
	err := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform", directory))
	require.NoError(t, err)
	err1 := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform.lock.hcl", directory))
	require.NoError(t, err1)
	err2 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate", directory))
	require.NoError(t, err2)
	err3 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate.backup", directory))
	require.NoError(t, err3)
}

func setup(t *testing.T, directory string, region string, terraformVars map[string]interface{}) *terraform.Options {

	retryableTerraformErrors := map[string]string{
		// The reason is unknown, but eventually these succeed after a few retries.
		".*unable to verify signature.*":                                       "Failed due to transient network error.",
		".*unable to verify checksum.*":                                        "Failed due to transient network error.",
		".*no provider exists with the given name.*":                           "Failed due to transient network error.",
		".*registry service is unreachable.*":                                  "Failed due to transient network error.",
		".*connection reset by peer.*":                                         "Failed due to transient network error.",
		".*TLS handshake timeout.*":                                            "Failed due to transient network error.",
		".*disassociating EC2 EIP.*The networkInterface ID .*does not exist.*": "Failed due to transient AWS error.",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../examples/%s", directory),
		// Variables to pass to our Terraform code using -var options
		Vars: terraformVars,
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
			"AWS_REGION":         region,
		},
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions
}
