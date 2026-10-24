
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
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 myusername"
    echo "  $0 myusername ghp_xxxxxxxxxxxxxxxxx"
    echo ""
}

# Display spinner animation.
spinner() {
    local pid="$1"
    local spin='|/-\'
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        printf " [%s]" "${spin:$((i % 4)):1}"
        sleep 0.1
        printf "\b\b\b\b"
        i=$((i + 1))
    done

    printf "    \b\b\b\b"
}

# Validate arguments.
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    show_help
    exit 1
fi

GITHUB_USERNAME="$1"
GITHUB_TOKEN="${2:-${GITHUB_TOKEN:-}}"
ASKPASS_SCRIPT=""

# Clean up temporary authentication script.
cleanup() {
    if [ -n "$ASKPASS_SCRIPT" ]; then
        rm -f "$ASKPASS_SCRIPT"
    fi
}

trap cleanup EXIT
trap 'echo -e "\n\nInterrupted!\n"; exit 130' INT
trap 'exit 143' TERM

# Configure temporary Git authentication.
if [ -n "$GITHUB_TOKEN" ]; then
    ASKPASS_SCRIPT=$(mktemp "${TMPDIR:-/tmp}/github-askpass.XXXXXX") || exit 1

    chmod 700 "$ASKPASS_SCRIPT"

    cat > "$ASKPASS_SCRIPT" <<'EOF'
#!/bin/sh

case "$1" in
    *Username*)
        printf '%s\n' "x-access-token"
        ;;
    *Password*)
        printf '%s\n' "$GITHUB_TOKEN"
        ;;
    *)
        exit 1
        ;;
esac
EOF
fi

# Execute Git commands with optional token authentication.
git_authenticated() {
    if [ -n "$GITHUB_TOKEN" ]; then
        GIT_ASKPASS="$ASKPASS_SCRIPT" \
        GIT_TERMINAL_PROMPT=0 \
        GITHUB_TOKEN="$GITHUB_TOKEN" \
        git -c credential.helper= "$@"
    else
        git "$@"
    fi
}

# Fetch data from GitHub API.
api_request() {
    local url="$1"

    if [ -n "$GITHUB_TOKEN" ]; then
        printf 'header = "Authorization: Bearer %s"\n' "$GITHUB_TOKEN" |
            curl -fsS --config - \
                -H "Accept: application/vnd.github+json" \
                "$url"
    else
        curl -fsS \
            -H "Accept: application/vnd.github+json" \
            "$url"
    fi
}

mkdir -p "$BACKUP_DIRECTORY"

repos=""
page=1
per_page=100

# Fetch repositories from GitHub API.
while :; do
    if [ -n "$GITHUB_TOKEN" ]; then
        api_url="https://api.github.com/user/repos?type=owner&per_page=$per_page&page=$page"
    else
        api_url="https://api.github.com/users/$GITHUB_USERNAME/repos?type=owner&per_page=$per_page&page=$page"
    fi

    if ! resp=$(api_request "$api_url"); then
        echo -e "\n${RED}GitHub API request failed.${NC}\n"
        exit 1
    fi

    urls=$(printf '%s\n' "$resp" |
        grep -o '"clone_url": "[^"]*' |
        cut -d'"' -f4)

    [ -z "$urls" ] && break

    repos="$repos"$'\n'"$urls"
    page=$((page + 1))
done

# Clean empty lines.
repos=$(printf '%s\n' "$repos" | sed '/^[[:space:]]*$/d')

# Check if repositories found.
if [ -z "$repos" ]; then
    echo -e "\n${RED}No repositories found.${NC}\n"
    exit 1
fi

# Display repository count.
total_repos=$(printf '%s\n' "$repos" | wc -l | tr -d '[:space:]')

echo ""
echo -e "${GREEN}Found $total_repos repositories.${NC}"
echo ""

success_count=0
current=0

# Clone or update repositories.
while IFS= read -r repo_url; do
    current=$((current + 1))

    repo_name=$(basename "$repo_url" .git)
    repo_path="$BACKUP_DIRECTORY/$repo_name"

    log_file=$(mktemp "${TMPDIR:-/tmp}/github-backup-log.XXXXXX") || exit 1

    printf "[$current/$total_repos] "

    if [ -d "$repo_path" ]; then
        printf "Updating: $repo_name"

        git_authenticated -C "$repo_path" pull --all >"$log_file" 2>&1 &
    else
        printf "Cloning: $repo_name"

        git_authenticated clone "$repo_url" "$repo_path" >"$log_file" 2>&1 &
    fi

    pid=$!
    spinner "$pid"

    if wait "$pid"; then
        echo -e "${GREEN} ✓${NC}"
        success_count=$((success_count + 1))
    else
        echo -e "${RED} ✗${NC}"

        # Display error details.
        sed -n '1,5p' "$log_file"
    fi

    rm -f "$log_file"
done <<< "$repos"

# Display backup summary.
echo ""
echo -e "${GREEN}Backup completed: $success_count/$total_repos repositories.${NC}"
echo ""

if [ "$success_count" -ne "$total_repos" ]; then
    exit 1
fi
