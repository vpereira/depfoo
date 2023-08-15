#!/bin/bash

# Set your GitLab instance URL, project ID and private token
# gitlab_url="https://gitlab.example.com"
# project_id="your_project_id"
# private_token="your_private_token"
source .env
project_id=$GITLAB_PROJECT_ID
gitlab_url=$GITLAB_URL
private_token=$PRIVATE_TOKEN
label="depfoo"

# Get all merge requests with the specific label and open state
merge_requests=$(curl -v --header "PRIVATE-TOKEN: $private_token" "$gitlab_url/$project_id/merge_requests?state=opened&labels=$label")

# Iterate over the merge requests and close each one
echo "$merge_requests" | jq -r '.[] | .iid' | while read merge_request_id
do
    echo "Closing merge request $merge_request_id" 
    curl --request PUT --header "PRIVATE-TOKEN: $private_token" "$gitlab_url/$project_id/merge_requests/$merge_request_id?state_event=close"
done

