# zoc — OpenShift Zsh helpers

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/TomerG2/zoc/releases)
[![ShellCheck](https://github.com/TomerG2/zoc/workflows/ShellCheck/badge.svg)](https://github.com/TomerG2/zoc/actions)

Small Zsh plugin with aliases and functions to speed up `oc` logins and token renewal.

## Install

### Oh My Zsh
```sh
git clone https://github.com/TomerG2/zoc ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zoc
# then in ~/.zshrc:
plugins+=(zoc)
exec zsh

### Commands

- **`oclog <alias> <api-server> <namespace>`** → logs you in with a short alias and optional namespace.
  - Tab completion available for namespace argument (requires active `oc` session)
- **`ocen`** → checks if your oc login has expired and refreshes the token if it has.
- **`ocp`** → combines ocensure && oc.

### Features

- ✅ **Auto-completion**: Tab completion for `oclog` namespace argument
- ✅ **Session renewal**: Automatic token refresh when expired
- ✅ **Clean aliases**: Short, memorable commands for common operations

### Workflow

1. Use `oclog` once to set up a context with a short name.
2. Use `ocp` instead of `oc` in daily work—it'll auto-renew your session if expired.

✅ **Execute oc commands with less steps**

## Development

This project uses:
- **ShellCheck**: Automated shell script linting via GitHub Actions
- **Versioned releases**: Tagged releases for stability
- **CI/CD**: Automated testing and release workflows

### Creating Releases

Use the provided script to create new releases:

```bash
./scripts/create-release.sh 1.0.0 "Initial release"
```

Or use the GitHub Actions workflow:
1. Go to Actions > Release > Run workflow
2. Enter version number and tag message
3. The workflow will create the tag and GitHub release automatically

### Examples

```bash
oclogin dev https://your-openshift-api-server:6443 my-namespace
# Creates a new context with the alias "dev", setting ns to "my-namespace"

ocp get pods
# Refreshes token if needed and exec "oc get pods"
```
