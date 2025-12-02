# Auto Tag Action

A GitHub Action that automatically creates semantic version tags based on PR content and commit messages.

## Features

- 🏷️ **Automatic Tagging**: Creates semantic version tags based on keywords in PR descriptions and commit messages
- 📝 **Smart Version Bumping**: Analyzes content for version bump keywords (major, minor, patch)
- 🚀 **GitHub Releases**: Automatically creates GitHub releases with detailed information
- ⚙️ **Configurable**: Customizable tag prefix, default bump type, and skip keywords
- 📊 **Detailed Output**: Provides comprehensive outputs and step summaries

## Usage

### Basic Usage

```yaml
name: Auto Tag on Merge

on:
  push:
    branches:
      - main

jobs:
  auto-tag:
    runs-on: ubuntu-latest
    if: ${{ !contains(github.event.head_commit.message, '[skip-tag]') }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Auto Tag
        uses: japhy-team/gh-actions/auto-tag@v0.1.0
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Advanced Usage

```yaml
- name: Auto Tag
  uses: japhy-team/gh-actions/auto-tag@v0.1.0
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    tag-prefix: "v"
    default-bump: "patch"
    skip-tag-keyword: "[skip-tag]"
```

## Inputs

| Input              | Description                                      | Required | Default               |
| ------------------ | ------------------------------------------------ | -------- | --------------------- |
| `github-token`     | GitHub token for API access and git operations   | Yes      | `${{ github.token }}` |
| `tag-prefix`       | Prefix for tags (e.g., "v" for v1.0.0)           | No       | `v`                   |
| `default-bump`     | Default version bump type when no keywords found | No       | `patch`               |
| `skip-tag-keyword` | Keyword in commit message to skip tagging        | No       | `[skip-tag]`          |

## Outputs

| Output             | Description                                              |
| ------------------ | -------------------------------------------------------- |
| `new-version`      | The new version that was created                         |
| `previous-version` | The previous version tag                                 |
| `bump-type`        | The type of version bump performed (major, minor, patch) |
| `tag-created`      | Whether a new tag was created (true/false)               |
| `pr-number`        | The PR number if found in commit message                 |

## Version Bump Keywords

The action analyzes PR descriptions and commit messages for the following keywords:

### Major Version Bump

- `major`
- `breaking`
- `breaking-change`
- `breaking_change`

### Minor Version Bump

- `minor`
- `feature`
- `feat`

### Patch Version Bump

- `patch`
- `fix`
- `bugfix`
- `hotfix`

## How It Works

1. **Extract PR Information**: Finds the PR number from merge commit messages and fetches PR details
2. **Analyze Content**: Searches for version bump keywords in PR descriptions and commit messages
3. **Calculate Version**: Determines the appropriate version bump based on found keywords
4. **Create Tag**: Creates an annotated git tag with release information
5. **Create Release**: Automatically creates a GitHub release with detailed notes

## Examples

### Example PR Description

```markdown
## Summary

This PR adds a new feature for user authentication.

### Changes

- Added login endpoint
- Added JWT token validation
- Updated user model

**Type**: feature
```

This would trigger a **minor** version bump due to the "feature" keyword.

### Example Commit Message

```
feat: add user authentication (#123)

- Implemented JWT-based authentication
- Added middleware for token validation
- Updated API documentation
```

This would trigger a **minor** version bump due to the "feat" keyword.

### Skipping Auto-Tagging

To skip automatic tagging for a specific commit, include `[skip-tag]` in the commit message:

```
docs: update README [skip-tag]
```

## Requirements

- Repository must have `fetch-depth: 0` in checkout action to access git history
- GitHub token must have permissions to create tags and releases
- Action should run on `push` events to the main branch

## Workflow Integration

This action works best when integrated into a workflow that runs after PRs are merged to the main branch:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      # ... test steps ...

  auto-tag:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Auto Tag
        uses: japhy-team/gh-actions/auto-tag@v0.1.0
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```
