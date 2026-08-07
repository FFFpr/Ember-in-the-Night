#!/usr/bin/env bash
# Idempotent Cloud Agent install for Ember in the Night (Linux VM only).
# Required tools (pin versions here — Cursor does not install by name alone):
#   - Godot 4.7.1 (README: Godot 4.7+)
#   - Python 3.13 (gda requirement)
#   - uv (package/tool runner)
#   - gda 0.9.0 with [mcp] extra
set -euo pipefail

GODOT_VERSION="4.7.1"
GODOT_TAG="${GODOT_VERSION}-stable"
GODOT_DIR="${HOME}/tools/godot"
GODOT_BIN="${GODOT_DIR}/Godot_v${GODOT_TAG}_linux.x86_64"
GODOT_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_TAG}/Godot_v${GODOT_TAG}_linux.x86_64.zip"
GDA_VERSION="0.9.0"
PYTHON_VERSION="3.13"

export PATH="${HOME}/.local/bin:${PATH}"

ensure_uv() {
  if command -v uv >/dev/null 2>&1; then
    echo "uv: $(uv --version)"
    return
  fi
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
  echo "uv: $(uv --version)"
}

ensure_python() {
  uv python install "${PYTHON_VERSION}"
  echo "python: $(uv python find "${PYTHON_VERSION}")"
}

ensure_gda() {
  # --force keeps the pin in sync when GDA_VERSION changes across Builds.
  uv tool install --force --python "${PYTHON_VERSION}" "gda[mcp]==${GDA_VERSION}"
  echo "gda: $(gda --version)"
}

ensure_godot() {
  mkdir -p "${GODOT_DIR}"
  if [[ -x "${GODOT_BIN}" ]]; then
    ver="$("${GODOT_BIN}" --version || true)"
    if [[ "${ver}" == "${GODOT_VERSION}."* ]]; then
      echo "godot: ${ver} (cached)"
    else
      echo "godot: unexpected cached binary (${ver}); re-downloading ${GODOT_TAG}"
      rm -f "${GODOT_BIN}"
    fi
  fi
  if [[ ! -x "${GODOT_BIN}" ]]; then
    tmp="$(mktemp -d)"
    curl -fsSL --retry 3 -o "${tmp}/godot.zip" "${GODOT_URL}"
    unzip -o "${tmp}/godot.zip" -d "${GODOT_DIR}"
    rm -rf "${tmp}"
    chmod +x "${GODOT_BIN}"
  fi
  mkdir -p "${HOME}/.local/bin"
  ln -sfn "${GODOT_BIN}" "${HOME}/.local/bin/godot"
  echo "godot: $(godot --version)"
}

ensure_env_exports() {
  # Persist for interactive / agent shells after Build snapshot.
  marker="# ember-in-the-night cloud agent tools"
  profile="${HOME}/.bashrc"
  if [[ -f "${profile}" ]] && grep -qF "${marker}" "${profile}"; then
    return
  fi
  {
    echo ""
    echo "${marker}"
    echo 'export PATH="$HOME/.local/bin:$PATH"'
    echo 'export GDA_GODOT="$HOME/.local/bin/godot"'
    # GDA_PROJECT is the checked-out workspace; Cursor sets cwd to the repo root.
    echo 'export GDA_PROJECT="${GDA_PROJECT:-$PWD}"'
  } >> "${profile}"
}

ensure_uv
ensure_python
ensure_gda
ensure_godot
ensure_env_exports

export GDA_GODOT="${HOME}/.local/bin/godot"
echo "install complete: Godot ${GODOT_VERSION}, Python ${PYTHON_VERSION}, gda ${GDA_VERSION}"
