#!/bin/bash
#
# Installs Lazify from the latest GitHub release.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Anuboost-Long/lazify-dist/main/install.sh | bash
#
# The build is signed ad-hoc rather than with a Developer ID, so a copy that
# arrives through a browser is quarantined and macOS calls it damaged. This
# clears the quarantine flag on a copy the user asked for by name, which is the
# whole reason the install is a script rather than a download link.
#
# ZIP_URL points somewhere else when testing a build before it is released:
#   ZIP_URL="file:///path/to/Lazify-arm64.zip" ./install.sh

set -euo pipefail

# The public release repo, never the source repo. Release assets inherit the
# repository's visibility, so a private repo's download URL answers 404 to
# anyone without a token — which would be every user of this script.
REPO="Anuboost-Long/lazify-dist"
APP_NAME="Lazify.app"

if [ "$(uname -s)" != "Darwin" ]; then
  echo "ERROR: this installer is for macOS. On Windows, download the installer from" >&2
  echo "       https://github.com/$REPO/releases" >&2
  exit 1
fi

# Lazify ships thin builds rather than a universal binary, so the right one has
# to be picked here.
MACHINE="$(uname -m)"
if [ "$MACHINE" = "arm64" ]; then
  ARCH="arm64"
elif [ "$MACHINE" = "x86_64" ]; then
  # A shell running under Rosetta reports x86_64 on Apple Silicon. Trusting it
  # would install the Intel build on a machine that can run the native one, and
  # the user would never be told why the app feels slow.
  if [ "$(sysctl -n hw.optional.arm64 2>/dev/null || echo 0)" = "1" ]; then
    ARCH="arm64"
    echo "==> Apple Silicon detected through Rosetta, installing the arm64 build"
  else
    ARCH="x64"
  fi
else
  echo "ERROR: unsupported architecture: $MACHINE" >&2
  exit 1
fi

ZIP_URL="${ZIP_URL:-https://github.com/$REPO/releases/latest/download/Lazify-$ARCH.zip}"

# /Applications is writable by admin users, but not by every account. Falling
# back keeps the install working without asking for a password.
TARGET_DIR="${INSTALL_DIR:-/Applications}"
if [ ! -w "$TARGET_DIR" ]; then
  TARGET_DIR="$HOME/Applications"
  mkdir -p "$TARGET_DIR"
  echo "==> /Applications is not writable, installing to $TARGET_DIR"
fi

TARGET="$TARGET_DIR/$APP_NAME"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Everything that can fail happens before the running copy is touched. Quitting
# the app first and then failing to download leaves the user worse off than if
# they had never run this.
echo "==> Downloading Lazify ($ARCH)"
if ! curl -fSL --progress-bar "$ZIP_URL" -o "$WORK/Lazify.zip"; then
  echo >&2
  echo "ERROR: could not download Lazify." >&2
  echo "       $ZIP_URL" >&2
  echo >&2
  echo "A 404 here means no release has been published yet. Check:" >&2
  echo "       https://github.com/$REPO/releases" >&2
  exit 1
fi

# ditto, not unzip: it is the extraction that keeps the code signature intact.
echo "==> Extracting"
ditto -x -k "$WORK/Lazify.zip" "$WORK/extracted"

if [ ! -d "$WORK/extracted/$APP_NAME" ]; then
  echo "ERROR: the download did not contain $APP_NAME." >&2
  exit 1
fi

# The signature is ad-hoc, so this proves only that the bytes arrived intact and
# nothing rewrote the bundle in transit. It is not a claim about who built it.
echo "==> Verifying the download"
if ! codesign --verify --strict "$WORK/extracted/$APP_NAME" 2>/dev/null; then
  echo "ERROR: the downloaded app failed signature verification." >&2
  exit 1
fi

# Only now, with a verified bundle in hand. Replacing the app under a running
# copy leaves it running from a path that no longer exists, and Lazify holds
# agent terminals and dev servers that would be orphaned with it.
if pgrep -x Lazify >/dev/null 2>&1; then
  echo "==> Quitting the running copy"
  osascript -e 'quit app "Lazify"' >/dev/null 2>&1 || true
  sleep 2
fi

echo "==> Installing to $TARGET"
rm -rf "$TARGET"
ditto "$WORK/extracted/$APP_NAME" "$TARGET"

# Downloads carry com.apple.quarantine, and an ad-hoc signature turns that into
# "damaged and can't be opened" rather than a prompt the user can dismiss.
xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true

echo
echo "Done. Installed $TARGET"
echo "Open it with:  open -a Lazify"
