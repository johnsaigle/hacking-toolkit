#!/bin/bash
# GitHub PR Content Extractor
# This script downloads and extracts content from a GitHub PR

set -e

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Please install it using your package manager:"
    echo "  - For Debian/Ubuntu: sudo apt-get install jq"
    echo "  - For macOS: brew install jq"
    echo "  - For CentOS/RHEL: sudo yum install jq"
    exit 1
fi

# Function to display usage information
show_usage() {
    echo "Usage: $0 <github-pr-url> [output-file]"
    echo ""
    echo "Example: $0 https://github.com/owner/repo/pull/123 pr-content.md"
    echo ""
    echo "If output-file is not specified, the content will be printed to stdout."
}

# Check if URL is provided
if [ -z "$1" ]; then
    show_usage
    exit 1
fi

PR_URL="$1"
OUTPUT_FILE="$2"

# Extract owner, repo and PR number from URL
if [[ $PR_URL =~ github\.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
    PR_NUMBER="${BASH_REMATCH[3]}"
else
    echo "Error: Invalid GitHub PR URL format."
    echo "Expected format: https://github.com/owner/repo/pull/123"
    exit 1
fi

# Function to fetch GitHub API data
fetch_github_data() {
    local endpoint="$1"
    local api_url="https://api.github.com/repos/$OWNER/$REPO/$endpoint"
    
    # Check if GITHUB_TOKEN is set and use it for authentication
    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -H "Authorization: token $GITHUB_TOKEN" "$api_url"
    else
        echo "Note: No GITHUB_TOKEN environment variable found. Using unauthenticated API." >&2
        echo "You may encounter rate limiting. Set GITHUB_TOKEN for better results." >&2
        curl -s "$api_url"
    fi
}

# Create a temporary file
TEMP_FILE=$(mktemp)

# Get PR details
echo "Fetching PR details for $OWNER/$REPO PR #$PR_NUMBER..." >&2
PR_DATA=$(fetch_github_data "pulls/$PR_NUMBER")

# Extract PR title and body
PR_TITLE=$(echo "$PR_DATA" | jq -r '.title')
PR_BODY=$(echo "$PR_DATA" | jq -r '.body // "No description provided."')
PR_AUTHOR=$(echo "$PR_DATA" | jq -r '.user.login')
PR_CREATED_AT=$(echo "$PR_DATA" | jq -r '.created_at')

# Write PR details to temp file
cat > "$TEMP_FILE" << EOF
# Pull Request: $PR_TITLE

**PR #$PR_NUMBER by @$PR_AUTHOR on $PR_CREATED_AT**

==== PR BODY

$PR_BODY

==== END PR BODY

EOF

# Get PR comments (these are the top-level comments, not review comments)
echo "Fetching PR comments..." >&2
PR_COMMENTS=$(fetch_github_data "issues/$PR_NUMBER/comments")

# Check if we got valid comments
if ! echo "$PR_COMMENTS" | jq -e '.' > /dev/null 2>&1; then
    echo "Error fetching comments. API response:" >&2
    echo "$PR_COMMENTS" >&2
    rm -f "$TEMP_FILE"
    exit 1
fi

# Process comments
COMMENT_COUNT=$(echo "$PR_COMMENTS" | jq length)
echo "Found $COMMENT_COUNT comments" >&2

if [ "$COMMENT_COUNT" -gt 0 ]; then
    echo "$PR_COMMENTS" | jq -r '.[] | "===== BEGIN COMMENT\n## @\(.user.login) commented on \(.created_at)\n\n\(.body)\n===== END COMMENT\n"' >> "$TEMP_FILE"
else
    echo "No comments found on this PR." >> "$TEMP_FILE"
fi

# If output file is specified, save to file, otherwise print to stdout
if [ -n "$OUTPUT_FILE" ]; then
    mv "$TEMP_FILE" "$OUTPUT_FILE"
    echo "PR content has been saved to $OUTPUT_FILE" >&2
else
    cat "$TEMP_FILE"
    rm -f "$TEMP_FILE"
fi
