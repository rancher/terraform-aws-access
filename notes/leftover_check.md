# Leftovers

I ran into an error where we had reached the EIP limit because I forgot to clean up after a catastrophic failure testing locally.

I decided that the best way to prevent this would be to fail the release if leftovers found anything.

Leftovers is a tool for finding resources in AWS given a filter, it works really well and solves a lot of problems for infrastructure testing.
