#!/bin/bash

# Swap the environment variables using the GitHub API for Repository Variables
#read-first-the-variables
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables

# Get current values of PROD_BUCKET and STAGE_BUCKET
PROD_BUCKET_VALUE=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/PROD_BUCKET \
  | jq -r .value)

STAGE_BUCKET_VALUE=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/STAGE_BUCKET \
  | jq -r .value)

# Swap the values for PROD_BUCKET and STAGE_BUCKET
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/PROD_BUCKET \
  -d "{\"name\": \"PROD_BUCKET\", \"value\": \"$STAGE_BUCKET_VALUE\"}"

curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/STAGE_BUCKET \
  -d "{\"name\": \"STAGE_BUCKET\", \"value\": \"$PROD_BUCKET_VALUE\"}"

# Get current values of PROD_ALB and STAGE_ALB
PROD_ALB_VALUE=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/PROD_ALB \
  | jq -r .value)

STAGE_ALB_VALUE=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/STAGE_ALB \
  | jq -r .value)

# Swap the values for PROD_ALB and STAGE_ALB
curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/PROD_ALB \
  -d "{\"name\": \"PROD_ALB\", \"value\": \"$STAGE_ALB_VALUE\"}"

curl -L \
  -X PATCH \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables/STAGE_ALB \
  -d "{\"name\": \"STAGE_ALB\", \"value\": \"$PROD_ALB_VALUE\"}"



# Read variables-after-updating
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PAT_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/${GITHUB_REPOSITORY}/actions/variables
