#!/bin/bash

# Set error handling
set -e

AUTHOR="johnsaigle"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI is not installed. Please install it from https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "You need to authenticate with GitHub first. Run: gh auth login"
    exit 1
fi

# echo "Fetching pull requests for wormhole-foundation/wormhole..."

# Fetch all open PRs for the specified repository
# Format the output as JSON for easier parsing
prs=$(gh pr list \
    --repo wormhole-foundation/wormhole \
    --json title,author,number,url,isDraft,statusCheckRollup \
    --limit 100)  # Adjust limit if needed

# Parse JSON and filter PRs
# echo "Filtering non-draft PRs with passing CI checks..."

echo "$prs" | jq -r '.[] | 
    select(.isDraft == false) | 
    select(.author.login == "'"$AUTHOR"'") |
    select(
        (.statusCheckRollup | length) > 0 and 
        (.statusCheckRollup | all(.status == "COMPLETED"))
    ) | 
    "\(.title)\n\(.url)\n"' | while read -r line; do
    echo "$line"
done


# echo "Done!"
