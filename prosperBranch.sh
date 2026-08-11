#!/bin/bash

read -p "Enter your token: " GITHUB_TOKEN
pr
echo "Token saved: $GITHUB_TOKEN"
OWNER="eoyebami"
REPO="bootcamp-apis"
BRANCH="prosper_Branch"
MAIN="main"

# Get the SHA of the main branch
SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \ "https://api.github.com/repos/$OWNER/$REPO/git/refs/<F6>heads/$MAIN" 

echo "Your SHA: $SHA"

# creating a new branch
curl -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \ -H "Accept: application/vnd.github+json" \ "https://api.github.com/repos/$OWNER/$REPO/git/refs" \ -d "{\"ref\": \"refs/heads/$BRANCH\", \"sha\": \"$SHA\"}"

# check to see if the branch was created
curl -L -H "Authorization: Bearer $GITHUB_TOKEN" \ "https://api.github.com/repos/$OWNER/$REPO/branches" 


# Delete new branch
curl -X DELETE -H "Authorization: Bearer $GITHUB_TOKEN" \ "https://api.github.com/repos/$OWNER/$REPO/git/refs/heads/$BRANCH"

# check to see if the branch was deleted
curl -L -H "Authorization: Bearer $GITHUB_TOKEN" \ "https://api.github.com/repos/$OWNER/$REPO/branches"
