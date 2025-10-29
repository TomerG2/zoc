# zoc — OpenShift Shell helpers

[![Version](https://img.shields.io/badge/version-1.2.3-blue.svg)](https://github.com/TomerG2/zoc/releases)
[![ShellCheck](https://github.com/TomerG2/zoc/workflows/ShellCheck/badge.svg)](https://github.com/TomerG2/zoc/actions)

- Shell plugin with aliases and functions to speed up `oc` logins and token renewal. 
- Works with both **Zsh** and **Bash**.

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

### For Zsh (Oh My Zsh)
1. Clone zoc to your plugin directory:
```sh
git clone https://github.com/TomerG2/zoc ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zoc
```
2. Add to your `~/.zshrc`:
```sh
plugins+=(zoc)
```
3. Restart your shell:
```sh
exec zsh
```

### For Bash
1. Clone zoc to a directory of your choice:
```sh
git clone https://github.com/TomerG2/zoc ~/.zoc
```
2. Add to your `~/.bashrc` or `~/.bash_profile`:
```sh
source ~/.zoc/zoc.sh
```
3. Restart your shell or run:
```sh
source ~/.bashrc  # or ~/.bash_profile
```

### For Zsh (without Oh My Zsh)
1. Clone zoc to a directory of your choice:
```sh
git clone https://github.com/TomerG2/zoc ~/.zoc
```
2. Add to your `~/.zshrc`:
```sh
source ~/.zoc/zoc.sh
```
3. Restart your shell:
```sh
exec zsh
```

## Commands

- **`oclog <alias> <api-server> <namespace>`** → logs you in with a short alias and optional namespace.
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

### Release Process

The release process is split into two phases for better control and transparency:

#### Phase 1: Version Bump (During PR)

Before merging your changes, bump the version numbers in your PR:

```bash
./scripts/bump-version.sh 1.2.0
```

This updates version numbers in `zoc.sh` and `README.md`. Commit these changes as part of your PR so reviewers can see what version is being released.

#### Phase 2: Create Release (After Merge to Main)

After your PR is merged to `main`, create the actual release:

**Option A: Manual Script**
```bash
./scripts/create-release.sh 1.2.0 "Added new features"
```

**Option B: GitHub Actions (Recommended)**
1. Go to Actions > Release > Run workflow
2. Enter the same version number used in Phase 1
3. The workflow will verify version consistency and create the release automatically

The release process will fail if the version in files doesn't match the requested release version, ensuring consistency.
