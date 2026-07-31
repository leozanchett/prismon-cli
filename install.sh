#!/bin/sh
# Instala o prismon CLI a partir do GitHub Releases (repo público, sem auth).
#
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/leozanchett/prismon-cli/main/install.sh | sh
#   PRISMON_VERSION=0.1.0 sh install.sh   # versão específica
#
# Variáveis:
#   PRISMON_VERSION      versão sem o "v" (default: latest)
#   PRISMON_INSTALL_DIR  default: ~/.local/bin
set -eu

REPO="leozanchett/prismon-cli"
INSTALL_DIR="${PRISMON_INSTALL_DIR:-$HOME/.local/bin}"

log() { printf 'prismon-install: %s\n' "$*" >&2; }
fail() { printf 'prismon-install: erro: %s\n' "$*" >&2; exit 1; }

detect_platform() {
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"
  case "$os" in
    darwin|linux) ;;
    *) fail "sistema $os não suportado por este script (no Windows, baixe o .zip do release)" ;;
  esac
  case "$arch" in
    x86_64|amd64) arch="amd64" ;;
    arm64|aarch64) arch="arm64" ;;
    *) fail "arquitetura $arch não suportada" ;;
  esac
  printf '%s_%s' "$os" "$arch"
}

resolve_version() {
  if [ -n "${PRISMON_VERSION:-}" ]; then
    printf '%s' "$PRISMON_VERSION"
    return
  fi
  curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | sed -n 's/.*"tag_name": *"v\{0,1\}\([^"]*\)".*/\1/p' | head -1
}

main() {
  platform="$(detect_platform)"
  version="$(resolve_version)"
  [ -n "$version" ] || fail "não foi possível resolver a versão (nenhum release em https://github.com/$REPO/releases)"
  log "versão $version, plataforma $platform"

  bundle="prismon_${version}_${platform}.tar.gz"
  url="https://github.com/$REPO/releases/download/v${version}/${bundle}"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  log "baixando $url"
  curl -fsSL "$url" -o "$tmpdir/$bundle" || fail "download falhou — confira se o release v$version tem o asset $bundle"

  tar -xzf "$tmpdir/$bundle" -C "$tmpdir" -O prismon > "$tmpdir/prismon-bin" \
    || fail "pacote não contém o binário prismon"

  mkdir -p "$INSTALL_DIR"
  cp "$tmpdir/prismon-bin" "$INSTALL_DIR/prismon"
  chmod +x "$INSTALL_DIR/prismon"
  xattr -d com.apple.quarantine "$INSTALL_DIR/prismon" 2>/dev/null || true

  if command -v shasum >/dev/null 2>&1; then
    sums_url="https://github.com/$REPO/releases/download/v${version}/prismon_${version}_checksums.txt"
    if curl -fsSL "$sums_url" -o "$tmpdir/checksums.txt" 2>/dev/null; then
      expected="$(grep "  $bundle\$" "$tmpdir/checksums.txt" | awk '{print $1}')"
      actual="$(shasum -a 256 "$tmpdir/$bundle" | awk '{print $1}')"
      if [ -n "$expected" ] && [ "$expected" != "$actual" ]; then
        rm -f "$INSTALL_DIR/prismon"
        fail "checksum não confere (esperado $expected, obtido $actual)"
      fi
      [ -n "$expected" ] && log "checksum ok"
    fi
  fi

  log "instalado em $INSTALL_DIR/prismon"
  case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *) log "aviso: $INSTALL_DIR não está no PATH — adicione ao seu ~/.zshrc" ;;
  esac
  log "rode: prismon"
}

main "$@"
