# zoc — OpenShift Zsh helpers

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/TomerG2/zoc/releases)
[![ShellCheck](https://github.com/TomerG2/zoc/workflows/ShellCheck/badge.svg)](https://github.com/TomerG2/zoc/actions)

Small Zsh plugin with aliases and functions to speed up `oc` logins and token renewal.

### With zoc
<img src="https://github.com/user-attachments/assets/8997d2c6-8dbd-4bf0-829b-4c8a9a12d2ae" alt="with zoc" width="400"/>

- ⏱️ Time: **10 seconds**
- 🖱️ Clicks: **2**

---

### Without zoc
<img src="https://github.com/user-attachments/assets/6aa86434-540b-43a6-b177-825518a3fedc" alt="without zoc" width="400"/>

- ⏱️ Time: **30 seconds**
- 🖱️ Clicks: **8**

## Install
1. Clone zoc to your plugin directory:
```sh
git clone https://github.com/TomerG2/zoc ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zoc
```
2. Then in `~/.zshrc`:
```sh
plugins+=(zoc)
exec zsh
```

## Commands

- **`oclog <alias> <api-server> <namespace>`** → logs you in with a short alias and optional namespace.
  - Tab completion available for namespace argument (requires active `oc` session)
- **`ocen`** → checks if your oc login has expired and refreshes the token if it has.
- **`ocp`** → combines ocensure && oc.


### Examples

```bash
oclogin dev https://your-openshift-api-server:6443 my-namespace
# Creates a new context with the alias "dev", setting ns to "my-namespace"

ocen
# Check if the token has expired and refreshes it if needed

ocp get pods
# Refreshes token if needed and exec "oc get pods"
```

## Development

### Creating Releases

Use the provided script to create new releases:

```bash
./scripts/create-release.sh 1.0.0 "Initial release"
```

Or use the GitHub Actions workflow:
1. Go to Actions > Release > Run workflow
2. Enter version number and tag message
3. The workflow will create the tag and GitHub release automatically
