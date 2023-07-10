# Examples

These are example implementations of this module.
These modules use relative path sourcing so that they can be easily tested by the automation in this repo.
When users implement these modules, please use the Terraform registry.
Set the source attribute equal to the group and name of the module, and the version to the version you would like to use.

## Basic

This generates all possible objects, this is a basic Terraform run without exclusions.

## Override

This generates no objects, this is a full override of the module.

## Personal

This generates only "personal" objects, skipping the creation of a VPC and a subnet.

## Project

This generates only "project" objects, generating a subnet and matching security group, but skipping everything else.
