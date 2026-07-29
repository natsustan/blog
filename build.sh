#!/usr/bin/env bash

set -euo pipefail

readonly HUGO_VERSION="0.164.0"

if [[ -f .gitmodules ]]; then
  git submodule update --init --recursive
fi

if ! command -v hugo >/dev/null 2>&1; then
  if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
    echo "Hugo ${HUGO_VERSION} or newer is required." >&2
    echo "Install it locally with: mise use hugo@${HUGO_VERSION}" >&2
    exit 1
  fi

  readonly temp_dir="$(mktemp -d)"
  trap 'rm -rf "${temp_dir}"' EXIT

  mkdir -p "${HOME}/.local/hugo"
  curl -sfL \
    -o "${temp_dir}/hugo.tar.gz" \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz"
  tar -C "${HOME}/.local/hugo" -xf "${temp_dir}/hugo.tar.gz"
  export PATH="${HOME}/.local/hugo:${PATH}"
fi

hugo --cleanDestinationDir --gc --minify
