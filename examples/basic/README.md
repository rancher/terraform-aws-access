# Basic Example

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
This example deploys a new VPC in your default region, then a subnet within that VPC, a new SSH key to access servers, and a new security group to restrict server access.

NOTE: It is important to note that this module doesn't generate an ssh key, it imports a given public key to AWS.
This is because you will need the private key added to your ssh agent,
this module (as well as others we create) rely on the security built into open-ssh to manage ssh keys.

Check out the `basic_test.go` for a simple way to generate a key to hand to this module using the Terratest ssh module.
