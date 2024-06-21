#!/bin/sh

if [ -z "$API_URL" ]; then API_URL="https://api.github.com"; fi
if [ -z "$REPO" ]; then REPO="rancher/terraform-aws-access"; fi
if [ -z "$GITHUB_OUPUT" ]; then GITHUB_OUTPUT="/tmp/terraform-aws-access-cleanup.out"; fi

get_ids() {
  curl -s \
    --header "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${API_URL}/repos/${REPO}/actions/runs" \
    | jq -r '.workflow_runs[] | 
        select(.created_at > (now - 86400)) | 
        select(.status != "in_progress") | 
        select((.name |= ascii_downcase | .name) == "release") | 
        "\((.name |= ascii_downcase | .name))-\(.id)-\(.run_number)-\(.run_attempt)"' \
    | jq -R -s -c 'split("\n")[:-1]'
}
DATA="$(get_ids)"
echo ids="$DATA"
echo ids="$DATA" >> "$GITHUB_OUTPUT"
