# shellcheck shell=bash
# zoc.plugin.zsh — OpenShift login/renew helpers for bash and zsh
# Version: 1.2.1

# Aliases
alias octx="oc config get-contexts"
alias ocur="oc config current-context"
alias ocu="oc config use-context"
alias ocdel="oc config delete-context"
alias ocp='ocen && oc'

# Functions
oclog () {
  # Usage: oclog <alias> <api-server> [namespace]
  # Example: oclog dev https://api.my.openshift.example.com:6443 my-team
  local alias="$1"; local server="$2"; local ns="${3:-default}"
  if [ -z "$alias" ] || [ -z "$server" ]; then
    echo "Usage: oclog <alias> <api-server> [namespace]"; return 1
  fi

  # Delete context if alias already exists
  if oc config get-contexts "$alias" >/dev/null 2>&1; then
    oc config delete-context "$alias" >/dev/null 2>&1
  fi

  oc login --web --server="$server" >/dev/null || return $?

  local cur; cur="$(oc config current-context 2>/dev/null)" || return $?

  if [ "$cur" != "$alias" ]; then
    oc config rename-context "$cur" "$alias" >/dev/null 2>&1
  fi

  oc config set-context "$alias" --namespace="$ns" >/dev/null
  echo "✅ Logged in, Context: $alias  Namespace: $ns"
}

ocen () {
  # Check login
  if ! oc whoami >/dev/null 2>&1; then
    echo "🔄 Session expired. Re-logging…"

    # Find current context name and namespace
    local cur alias ns
    cur="$(oc config current-context 2>/dev/null)" || true
    if [ -n "$cur" ]; then
      alias="$cur"
      ns="$(oc config view -o jsonpath="{.contexts[?(@.name==\"$cur\")].context.namespace}")"
    fi

    # reuse cluster server URL from kubeconfig if available
    local server
    server="$(oc config view -o jsonpath="{.clusters[?(@.name==\"$(oc config view -o jsonpath='{.contexts[?(@.name=="'"$cur"'")].context.cluster}')\")].cluster.server}")"

    if [ -z "$server" ]; then
      echo "❌ Cannot detect cluster server URL from kubeconfig"
      return 1
    fi

    oclog "$alias" "$server" "$ns"
  fi
}

