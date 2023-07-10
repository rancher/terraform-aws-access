# Personal Example

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.

This example selects objects not considered "personal", resulting in similar output as the basic example usage.
This module will fail if it is not able to produce expected output.
When working with a team, it is usually true that there is a shared VPC and subnet,
 but each team member has their own security group and ssh key for server access.
Therefore this example selects a VPC and subnet by name, then generates an ssh key and server security group.
