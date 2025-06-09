# Docker Build and Push Action

A reusable GitHub Action for building and pushing Docker images to GitHub Container Registry (or other registries).

## Features

- 🐳 Build Docker images with custom context and Dockerfile paths
- 🚀 Push to any container registry (defaults to GitHub Container Registry)
- 🏷️ Automatic tagging with latest, git SHA, and custom version tags
- 🔧 Support for build arguments and multi-platform builds
- ⚙️ Flexible configuration options

## Inputs

| Input             | Description                                            | Required | Default        |
| ----------------- | ------------------------------------------------------ | -------- | -------------- |
| `checkout-ref`    | The git reference to checkout (commit, tag, or branch) | No       | `""`           |
| `registry`        | Container registry URL                                 | No       | `ghcr.io`      |
| `gh-username`     | GitHub username for registry authentication            | Yes      | -              |
| `gh-token`        | GitHub token/PAT for registry authentication           | Yes      | -              |
| `dockerfile-path` | Path to the Dockerfile                                 | No       | `./Dockerfile` |
| `context`         | Build context path                                     | No       | `.`            |
| `platforms`       | Target platforms for multi-platform builds             | No       | `linux/amd64`  |
| `image-name`      | Docker image name (without registry prefix)            | Yes      | -              |
| `version-tag`     | Version tag for the image                              | No       | `""`           |
| `additional-tags` | Additional tags (newline separated)                    | No       | `""`           |
| `build-args`      | Build arguments (newline separated key=value pairs)    | No       | `""`           |
| `push`            | Whether to push the image                              | No       | `true`         |

## Usage

### Basic Usage

```yaml
- name: Build and push Docker image
  uses: ./gh-actions/docker-build-push
  with:
    gh-username: ${{ secrets.GH_GO_MODULES_USER }}
    gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
    image-name: japhy-team/my-app
```

### Advanced Usage (Similar to your original job)

```yaml
docker:
  name: Push docker image to Github Packages
  needs: auto-tag
  runs-on: self-hosted
  steps:
    - name: Build and push Docker image
      uses: ./gh-actions/docker-build-push
      with:
        checkout-ref: ${{ needs.auto-tag.outputs.new-version }}
        gh-username: ${{ secrets.GH_GO_MODULES_USER }}
        gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
        dockerfile-path: ./build/package/Dockerfile
        platforms: linux/arm64
        image-name: japhy-team/chase
        version-tag: ${{ needs.auto-tag.outputs.new-version }}
        build-args: |
          GH_GO_MODULES_USER=${{ secrets.GH_GO_MODULES_USER }}
          GH_GO_MODULES_PAT=${{ secrets.GH_GO_MODULES_PAT }}
```

### With Additional Tags

```yaml
- name: Build and push Docker image
  uses: ./gh-actions/docker-build-push
  with:
    gh-username: ${{ secrets.GH_GO_MODULES_USER }}
    gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
    image-name: japhy-team/my-app
    version-tag: v1.2.3
    additional-tags: |
      stable
      production
      v1.2
      v1
```

### Build Only (No Push)

```yaml
- name: Build Docker image
  uses: ./gh-actions/docker-build-push
  with:
    gh-username: ${{ secrets.GH_GO_MODULES_USER }}
    gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
    image-name: japhy-team/my-app
    push: false
```

## Generated Tags

The action automatically generates the following tags:

1. `latest` - Always applied
2. `<git-sha>` - Current commit SHA
3. `<version-tag>` - If `version-tag` input is provided
4. Any additional tags from `additional-tags` input

For example, with `image-name: japhy-team/chase` and `version-tag: v1.2.3`, the following tags would be generated:

- `ghcr.io/japhy-team/chase:latest`
- `ghcr.io/japhy-team/chase:abc1234` (git SHA)
- `ghcr.io/japhy-team/chase:v1.2.3`

## Multi-platform Builds

To build for multiple platforms:

```yaml
- name: Build multi-platform image
  uses: ./gh-actions/docker-build-push
  with:
    gh-username: ${{ secrets.GH_GO_MODULES_USER }}
    gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
    image-name: japhy-team/my-app
    platforms: linux/amd64,linux/arm64
```

## Build Arguments

Pass build arguments to your Dockerfile:

```yaml
- name: Build with arguments
  uses: ./gh-actions/docker-build-push
  with:
    gh-username: ${{ secrets.GH_GO_MODULES_USER }}
    gh-token: ${{ secrets.GH_GO_MODULES_PAT }}
    image-name: japhy-team/my-app
    build-args: |
      NODE_VERSION=18
      BUILD_ENV=production
      API_KEY=${{ secrets.API_KEY }}
```
