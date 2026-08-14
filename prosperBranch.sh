#!/bin/bash

read -p "Enter your token: " GITHUB_TOKEN
OWNER="eoyebami"
REPO="bootcamp-apis"
TARGET_BRANCH="prosper_Branch"
SOURCE_BRANCH="main"

# Get the SHA of the main branch
SHA=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
	"https://api.github.com/repos/$OWNER/$REPO/git/refs/heads/$SOURCE_BRANCH" | jq -r '.object.sha')

# Create a new branch
curl -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
	-H "Accept: application/vnd.github+json" \
	-H "Content-Type: application/json" \
	"https://api.github.com/repos/$OWNER/$REPO/git/refs" \
	-d "{\"ref\": \"refs/heads/$TARGET_BRANCH\", \"sha\": \"$SHA\"}"

# Check to see if the branch was created
STATUS=$(curl -L \
	-s -o /dev/null -w "%{http_code}" \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: Bearer $GITHUB_TOKEN" \
	https://api.github.com/repos/$OWNER/$REPO/branches)

if [ "$STATUS" -eq 200 ]; then
	echo "Branch was created"
else
	echo "Branch Failed"
	exit 1
fi

# Delete the branch
curl -X DELETE \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    "https://api.github.com/repos/$OWNER/$REPO/git/refs/heads/$TARGET_BRANCH"

# Check to see if the branch was deleted
STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
	-H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    "https://api.github.com/repos/$OWNER/$REPO/git/refs/heads/$TARGET_BRANCH")

if [ "$STATUS" -eq 404 ]; then
	echo "Branch was removed"
	exit 0
else
	echo "Failed to remove branch"
	exit 1
fi
