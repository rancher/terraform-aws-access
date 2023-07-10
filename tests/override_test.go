package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates no objects, but validates that they exist
// this is a typical experience when you already have all the things you need to access servers in a project,
//   but you want to make sure the access objects exist before building anything else
func TestOverride(t *testing.T) {
  t.Parallel()
  terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    TerraformDir: "../examples/override",
   })

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)
}
