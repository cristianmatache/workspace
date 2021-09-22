#!/usr/bin/env bash

CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
ALERTMANAGER_HOME="${ALERTMANAGER_HOME:-${HOME}/alertmanager}"
VERSION="${ALERTMANAGER_VERSION:-0.22.1}"
OS="${PROMETHEUS_OS:-$(get_running_os)}"
ARCHITECTURE="${PROMETHEUS_ARCHITECTURE:-386}"

DEFAULT_DIR="alertmanager-$VERSION.$OS-$ARCHITECTURE"
TAR_GZ_FNAME="$DEFAULT_DIR.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/alertmanager/releases/download/v$VERSION/$TAR_GZ_FNAME"
echo "Alertmanager home is: $ALERTMANAGER_HOME"
echo "Download URL is: $DOWNLOAD_URL"

ORIGINAL_DIR=$(pwd)
mkdir -p "$ALERTMANAGER_HOME"
cd "$ALERTMANAGER_HOME" || exit 1

# Download
curl -LO "$DOWNLOAD_URL"
# Uncompress
tar -xvf "$TAR_GZ_FNAME"
# Move files out to ALERTMANAGER_HOME and get rid of long name
mv "$DEFAULT_DIR"/* .
rm -rf "$DEFAULT_DIR"

cd "$ORIGINAL_DIR" || exit 1
echo "--------------------- INSTALLED ALERTMANAGER ---------------------"
"$ALERTMANAGER_HOME"/alertmanager --version
echo "------------------------------------------------------------------"
echo "Please add '$ALERTMANAGER_HOME' to your \$PATH"
