# Override Example

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.

This example overrides all objects generating nothing, but resulting in similar output as the basic example usage.
It is important to note that this does not import the objects or try to control them, just find them and use data about them.
This module will fail if it is not able to produce expected output.
