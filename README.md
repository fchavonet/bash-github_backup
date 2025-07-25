<img height="50px" align="right" src="https://raw.githubusercontent.com/fchavonet/fchavonet/refs/heads/main/assets/images/logo-bash.png" alt="Bash logo">

# GitHub Backup

## 🔖 Table of contents

<details>
    <summary>
        CLICK TO ENLARGE 😇
    </summary>
    📄 <a href="#description">Description</a>
    <br>
    🎓 <a href="#objectives">Objectives</a>
    <br>
    🔨 <a href="#tech-stack">Tech stack</a>
    <br>
    📂 <a href="#files-description">Files description</a>
    <br>
    💻 <a href="#installation_and_how_to_use">Installation and how to use</a>
    <br>
    🔧 <a href="#whats-next">What's next?</a>
    <br>
    ♥️ <a href="#thanks">Thanks</a>
    <br>
    👷 <a href="#authors">Authors</a>
</details>

## 📄 <span id="description">Description</span>

GitHub Backup is a robust Bash script designed to automatically clone and maintain local backups of all repositories from any GitHub user account.

Born from the need for a reliable backup solution after hearing stories of developers losing their entire work portfolio (though rare, it can happen), this script provides peace of mind by creating comprehensive local backups that can be easily stored on external drives or compressed for archival purposes.

The script intelligently handles both public repositories (without authentication) and private repositories (with personal access token), making it capable of backing up even the largest GitHub accounts with 100+ repositories while respecting API rate limits and providing real-time progress feedback.

## 🎓 <span id="objectives">Objectives</span>

- Create a reliable automated backup solution for GitHub repositories.
- Handle both public and private repository access through GitHub API.
- Implement smart cloning and updating logic (clone new repositories, pull updates for existing ones).
- Provide clear visual feedback with colored output and progress indicators.
- Handle GitHub API rate limits gracefully with token-based authentication.
- Ensure robust error handling and clean interruption management.

## 🔨 <span id="tech-stack">Tech stack</span>

<p align="left">
    <img src="https://img.shields.io/badge/BASH-4eaa25?logo=gnubash&logoColor=white&style=for-the-badge" alt="Bash badge">
    <img src="https://img.shields.io/badge/GIT-f05032?logo=git&logoColor=white&style=for-the-badge" alt="Git badge">
    <img src="https://img.shields.io/badge/GITHUB-181717?logo=github&logoColor=white&style=for-the-badge" alt="GitHub badge">
    <img src="https://img.shields.io/badge/MARKDOWN-000000?logo=markdown&logoColor=white&style=for-the-badge" alt="Markdown badge">
    <img src="https://img.shields.io/badge/VS CODE-007acc?logo=data:image/svg+xml;base64,PCFET0NUWVBFIHN2ZyBQVUJMSUMgIi0vL1czQy8vRFREIFNWRyAxLjEvL0VOIiAiaHR0cDovL3d3dy53My5vcmcvR3JhcGhpY3MvU1ZHLzEuMS9EVEQvc3ZnMTEuZHRkIj4KDTwhLS0gVXBsb2FkZWQgdG86IFNWRyBSZXBvLCB3d3cuc3ZncmVwby5jb20sIFRyYW5zZm9ybWVkIGJ5OiBTVkcgUmVwbyBNaXhlciBUb29scyAtLT4KPHN2ZyBmaWxsPSIjZmZmZmZmIiB3aWR0aD0iODAwcHgiIGhlaWdodD0iODAwcHgiIHZpZXdCb3g9Ii0wLjUgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KDTxnIGlkPSJTVkdSZXBvX2JnQ2FycmllciIgc3Ryb2tlLXdpZHRoPSIwIi8+Cg08ZyBpZD0iU1ZHUmVwb190cmFjZXJDYXJyaWVyIiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiLz4KDTxnIGlkPSJTVkdSZXBvX2ljb25DYXJyaWVyIj4KDTxwYXRoIGQ9Im0xNy44NTggMjMuOTk4LTkuNzcxLTkuNDg0LTUuODY2IDQuNDY1LTIuMjIxLTEuMTE1di0xMS43MTlsMi4yMzQtMS4xMjEgNS44NyA0LjQ2OSA5Ljc0Ny05LjQ5MyA1LjU4NyAyLjIzOXYxOS41MzFsLTUuNTc5IDIuMjN6bS0uNTYzLTE2LjE4Ni01LjU3NyA0LjE3MyA1LjU4IDQuMjAyem0tMTQuNTA3IDEuNjg1djUuMDE2bDIuNzg3LTIuNTI1eiIvPgoNPC9nPgoNPC9zdmc+&logoColor=white&style=for-the-badge" alt="VS Code badge">
</p>

## 📂 <span id="files-description">Files description</span>

| **FILES**          | **DESCRIPTION**                                      |
| :----------------: | ---------------------------------------------------- |
| `assets`           | Contains the resources required for the repository.  |
| `github_backup.sh` | Main Bash script for backing up GitHub repositories. |
| `README.md`        | The README file you are currently reading 😉.        |

## 💻 <span id="installation_and_how_to_use">Installation and how to use</span>

**Installation:**

1. Clone this repository:
    - Open your preferred Terminal.
    - Navigate to the directory where you want to clone the repository.
    - Run the following command:

```bash
git clone https://github.com/fchavonet/bash-github_backup.git
```

2. Open the repository you've just cloned.

3. Make the script executable:

```bash
chmod +x github_backup.sh
```

**How to use:**

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
- GGenerate a new token with `repo` permissions.
- Use the token as the second parameter.

## 🔧 <span id="whats-next">What's next?</span>

- Implement selective backup (exclude/include specific repositories).
- Create a restore functionality to push backed-up repositories to a new account.

## ♥️ <span id="thanks">Thanks</span>

- A big thank you to the GitHub API team for providing such a comprehensive and well-documented API.

## 👷 <span id="authors">Authors</span>

**Fabien CHAVONET**
- GitHub: [@fchavonet](https://github.com/fchavonet)
