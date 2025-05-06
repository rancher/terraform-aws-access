package tests

import (
	"fmt"
	"os"
  "path/filepath"
	"testing"

  g "github.com/gruntwork-io/terratest/modules/git"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func Teardown(t *testing.T, directory string) {
  repoRoot, err := filepath.Abs(g.GetRepoRoot(t))
  if err != nil {
    t.Fatalf("Error getting git root directory: %v", err)
  }
  err = os.RemoveAll(fmt.Sprintf(repoRoot + "/examples/%s/.terraform", directory))
  if err != nil {
    t.Fatalf("Error removing .terraform directory: %v", err)
  }
	err = os.RemoveAll(fmt.Sprintf(repoRoot + "/examples/%s/.terraform.lock.hcl", directory))
  if err != nil {
    t.Fatalf("Error removing terraform lock file: %v", err)
  }
	err = os.RemoveAll(fmt.Sprintf(repoRoot + "/examples/%s/terraform.tfstate", directory))
  if err != nil {
    t.Fatalf("Error removing state file: %v", err)
  }
	err = os.RemoveAll(fmt.Sprintf(repoRoot + "/examples/%s/terraform.tfstate.backup", directory))
  if err != nil {
    t.Fatalf("Error remote state backup file: %v", err)
  }
}

func Setup(t *testing.T, directory string, region string, terraformVars map[string]interface{}) *terraform.Options {

  repoRoot, err := filepath.Abs(g.GetRepoRoot(t))
  if err != nil {
    t.Fatalf("Error getting git root directory: %v", err)
  }

  retryableTerraformErrors := map[string]string{
		// The reason is unknown, but eventually these succeed after a few retries.
		".*unable to verify signature.*":                                       "Failed due to transient network error.",
		".*unable to verify checksum.*":                                        "Failed due to transient network error.",
		".*no provider exists with the given name.*":                           "Failed due to transient network error.",
		".*registry service is unreachable.*":                                  "Failed due to transient network error.",
		".*connection reset by peer.*":                                         "Failed due to transient network error.",
		".*TLS handshake timeout.*":                                            "Failed due to transient network error.",
		".*disassociating EC2 EIP.*": 																					"Failed due to transient AWS error.",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf(repoRoot + "/examples/%s", directory),
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
