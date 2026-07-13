#!/bin/bash
token=""
api="https://api.github.com"
account_id=$(curl -s -X GET -H "Authorization: Bearer ${token}" "${api}/user" | jq .id)
new_desc="Favour was NOT HERE"

# Update description
curl -s -X PATCH -H "Authorization: Bearer ${token}" "${api}/repos/eoyebami/bootcamp-apis" -d "{\"description\":\"${new_desc}\"}" -o /dev/null
current_desc=$(curl -s -X GET -H "Authorization: Bearer ${token}" "${api}/repos/eoyebami/bootcamp-apis" | jq -r .description)
if [[ "${current_desc}" == "${new_desc}" ]]; then
  echo "description updated successfully 😊"
else
  echo "description failed to update😞"
  exit 1
fi

echo "YAY Script Ran with no issues"
