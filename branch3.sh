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
file_txt=$(curl -s -o /tmp/file_txt -w "%{http_code}" -X POST \
  -H "Authorization: Bearer $token" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$owner/$repo/git/refs \
  -d "{\"ref\":\"refs/heads/$new_branch\",\"sha\":\"$SHA\"}")

if [ "$file_txt" -eq 201 ]; then 
  echo "New branch created: $new_branch"
else
echo "New branch failed to create :("
 cat /tmp/file_txt
 exit 1
fi 

# Validate new branch
echo "Validating branch: $new_branch"
curl -s -H "Authorization: Bearer $token" \
  https://api.github.com/repos/$owner/$repo/branches/$new_branch | jq -r '.name'
echo "Done with validation"

# Delete branch
 echo "Deleting newly created branch: $new_branch"
 delete_file_txt=$(curl -s -o /tmp/file_txt -w "%{http_code}" -X DELETE \
  -H "Authorization: Bearer $token" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$owner/$repo/git/refs/heads/$new_branch)
 
 if [ "$delete_file_txt" -eq 204 ]; then
  echo "Branch deleted"
 else 
  echo "No branch detected"
  cat /tmp/file_txt
  exit 1
 fi 


