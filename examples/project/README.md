# Project Example

This example overrides only objects not considered "project" level, resulting in similar output as the basic example usage.
This module will fail if it is not able to produce expected output.
This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
When starting a new project which you expect to manage with a team, it is often true that you want to use an existing VPC,
 but you want to create a new network segment, so you need a new subnet.
You will need a new security group for the new network, but you will want to use your current ssh key.
