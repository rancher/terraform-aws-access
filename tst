#!/bin/bash
set -e

for region in us-west-1 us-west-2 us-east-1 us-east-2; do
  echo -n "leftovers in $region: "
  response="$( \
    leftovers -d --iaas=aws --aws-region="$region" --filter="Owner:terraform-ci" | \
      grep -v 'AccessDenied' | \
      grep -v 'status code' | \
      grep -v 'UnauthorizedOperation' \
    || true
  )"
  if [ -n "$response" ]; then
    echo "found leftovers: "
    echo "$response"
    echo "please clean up leftovers before release testing"
    exit 1
  else
    echo "none found"
  fi
done
