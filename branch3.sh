#!/bin/bash
token="$GITHUB_TOKEN"
repo="bootcamp-apis"
owner="eoyebami"
base="main"
new_branch="favour-feature-branch"

# Get the SHA of the base branch
echo "Getting SHA of base branch: $base"
SHA=$(curl -s -X GET \
  -H "Authorization: Bearer $token" \
  https://api.github.com/repos/$owner/$repo/git/refs/heads/$base | jq -r '.object.sha')
echo "Base SHA done"

# Create the branch
echo "Creating branch: $new_branch"
curl -s -X POST \
  -H "Authorization: Bearer $token" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$owner/$repo/git/refs \
  -d "{\"ref\":\"refs/heads/$new_branch\",\"sha\":\"$SHA\"}"


# Validate new branch
echo "Validating branch: $new_branch"
validated_branch=$(curl -s -H "Authorization: Bearer $token" \
	https://api.github.com/repos/$owner/$repo/branches/$new_branch | jq -r '.name')

if [[ "$validated_branch" -eq "$new_branch" ]]; then 
   echo "New Branch created successfully and validated."
else
    echo "Branch creation failed."
    exit 1
fi 

# Delete branch
 echo "Deleting newly created branch: $new_branch"
 curl -X DELETE \
  -H "Authorization: Bearer $token" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$owner/$repo/git/refs/heads/$new_branch


# Check if deleted branch still exist
deleted_branch=$(curl -s -H "Authorization: Bearer $token" \
        https://api.github.com/repos/$owner/$repo/branches/$new_branch | jq -r '.name')

if [[ "$deleted_branch" -eq "null" ]]; then 
  echo "Branch deleted successfully."
else
   echo "Branch deleted failed."
   exit 1
 fi 
