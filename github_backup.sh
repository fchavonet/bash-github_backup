#!/bin/bash

# Generate folder name with date in YYYY/MM/DD format.
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
BACKUP_DIRECTORY="./github_backup_(${YEAR}∕${MONTH}∕${DAY})"

# RGB colors.
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"

# No color.
NC="\033[0m"

# Clean Ctrl+C handling.
trap "echo -e '\n\n${RED}Interrupted!${NC}\n'; exit 1" INT

# Display help message.
show_help() {
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 <username> [token]"
    echo ""
    echo -e "${BLUE}Arguments:${NC}"
    echo "  username    Your GitHub username (required)."
    echo "  token       Your GitHub personal access token (optional)."
    echo ""
    echo -e "${BLUE}Note:${NC}"
    echo "  Token is required for accounts with 60+ repositories (GitHub API rate limit)."
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 myusername"
    echo "  $0 myusername ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    echo ""
}

# Display spinner animation.
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done

    printf "    \b\b\b\b"
}

# Validate arguments.
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    show_help
    exit 1
fi

GITHUB_USERNAME="$1"
GITHUB_TOKEN="$2"

mkdir -p "$BACKUP_DIRECTORY"

repos=""
page=1
per_page=100

# Fetch repositories from GitHub API.
while :; do
    if [ -n "$GITHUB_TOKEN" ]; then
        resp=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/user/repos?type=owner&per_page=$per_page&page=$page")
    else
        resp=$(curl -s \
            "https://api.github.com/users/$GITHUB_USERNAME/repos?type=owner&per_page=$per_page&page=$page")
    fi

    urls=$(echo "$resp" | grep -o '"clone_url": "[^"]*' | cut -d'"' -f4)
    [ -z "$urls" ] && break

    repos="$repos"$'\n'"$urls"
    ((page++))
done

# Clean empty lines.
repos=$(echo "$repos" | sed '/^\s*$/d')

# Check if repositories found.
if [ -z "$repos" ]; then
    echo ""
    echo -e "${RED}No repositories found or GitHub API error.${NC}"
    echo ""
    exit 1
fi

# Display found repositories count.
total_repos=$(echo "$repos" | wc -l)
echo ""
echo -e "${GREEN}Found $total_repos repositories.${NC}"
echo ""

success_count=0
current=0

# Clone or update repositories.
while IFS= read -r repo_url; do
    ((current++))
    repo_name=$(basename "$repo_url" .git)
    repo_path="$BACKUP_DIRECTORY/$repo_name"

    printf "[$current/$total_repos] "

    if [ -d "$repo_path" ]; then
        printf "Updating: $repo_name"

        (cd "$repo_path" && git pull --all >/dev/null 2>&1) &
        spinner $!
        wait $!

        if [ $? -eq 0 ]; then
            echo -e "${GREEN} ✓${NC}"
            ((success_count++))
        else
            echo -e "${RED} ✗${NC}"
        fi
    else
        printf "Cloning: $repo_name"

        git clone "$repo_url" "$repo_path" >/dev/null 2>&1 &
        spinner $!
        wait $!

        if [ $? -eq 0 ]; then
            echo -e "${GREEN} ✓${NC}"
            ((success_count++))
        else
            echo -e "${RED} ✗${NC}"
        fi
    fi
done <<<"$repos"

# Display backup summary.
echo ""
echo -e "${GREEN}Backup completed: $success_count/$total_repos repositories.${NC}"
echo ""
