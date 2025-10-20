# GitHub Backup

## Description

GitHub Backup is a Bash script designed to automatically clone and maintain local backups of all repositories from any GitHub user account.

Born from the need for a reliable backup solution after hearing stories of developers losing their entire work portfolio (though rare, it can happen), this script provides peace of mind by creating comprehensive local backups that can be easily stored on external drives or compressed for archival purposes.

The script intelligently handles both public repositories (without authentication) and private repositories (using a personal access token), making it capable of backing up even the largest GitHub accounts with 100+ repositories, all while respecting API rate limits and providing real-time progress feedback.

## Objectives

- Create a reliable automated backup solution for GitHub repositories.
- Handle both public and private repository access through GitHub API.
- Implement smart cloning and updating logic (clone new repositories, pull updates for existing ones).
- Provide clear visual feedback with colored output and progress indicators.
- Handle GitHub API rate limits gracefully with token-based authentication.
- Ensure robust error handling and clean interruption management.

## Tech Stack

![Bash badge](https://img.shields.io/badge/BASH-4eaa25?logo=gnubash&logoColor=white&style=for-the-badge)
![Git badge](https://img.shields.io/badge/GIT-f05032?logo=git&logoColor=white&style=for-the-badge)
![GitHub badge](https://img.shields.io/badge/GITHUB-181717?logo=github&logoColor=white&style=for-the-badge)

## File Description

| **FILE**          | **DESCRIPTION**                                      |
| :----------------: | ---------------------------------------------------- |
| `github_backup.sh` | Main Bash script for backing up GitHub repositories. |
| `README.md`        | The README file you are currently reading 😉.        |

## Installation & Usage

### Installation

1. Clone this repository:
    - Open your preferred Terminal.
    - Navigate to the directory where you want to clone the repository.
    - Run the following command:

```
git clone https://github.com/fchavonet/bash-github_backup.git
```

2. Open the cloned repository.

3. Make the script executable:

```
chmod +x github_backup.sh
```

> You need to have `curl` installed for the script to work.

### Usage

1. Basic usage (for public repositories):

```bash
./github_backup.sh your_github_username
```

2. With token (for private repositories or accounts with 60+ repos):

```bash
./github_backup.sh your_github_username your_github_token
```

3. Creating a GitHub token:
- Go to GitHub Settings > Developer settings > Personal access tokens.
- Generate a new token with `repo` permissions.
- Use the token as the second parameter.

## What's Next?

- Implement selective backup (exclude/include specific repositories).
- Create a restore functionality to push backed-up repositories to a new account.

## Thanks

- A big thank you to the GitHub API team for providing such a comprehensive and well-documented API.

## Author(s)

**Fabien CHAVONET**
- GitHub: [@fchavonet](https://github.com/fchavonet)
