#!/usr/bin/env bash

# Linux and WSL

CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
GRAFANA_HOME="$(dirname "${GRAFANA_HOME:-${HOME}/grafana/bin}")"
VERSION="${GRAFANA_VERSION:-8.0.0}"
OS="${GRAFANA_OS:-$(get_running_os)}"
ARCHITECTURE="${GRAFANA_ARCHITECTURE:-amd64}"

DEFAULT_DIR="grafana-$VERSION"
TAR_GZ_FNAME="grafana-$VERSION.$OS-$ARCHITECTURE.tar.gz"
DOWNLOAD_URL="https://dl.grafana.com/oss/release/$TAR_GZ_FNAME"
echo "Grafana home is: $GRAFANA_HOME"
echo "Download URL is: $DOWNLOAD_URL"

ORIGINAL_DIR=$(pwd)
mkdir -p "$GRAFANA_HOME"
cd "$GRAFANA_HOME" || exit 1

# Download
curl -LO "$DOWNLOAD_URL"
# Uncompress
tar -xvf "$TAR_GZ_FNAME"
# Move files out to GRAFANA_HOME and get rid of long name
mv "$DEFAULT_DIR"/* .
rm -rf "$DEFAULT_DIR"

cd "$ORIGINAL_DIR" || exit 1
echo "--------------------- INSTALLED GRAFANA ---------------------"
"$GRAFANA_HOME"/bin/grafana-server -v
"$GRAFANA_HOME"/bin/grafana-cli -v
echo "------------------------------------------------------------------"
echo "Please add '$GRAFANA_HOME/bin' to your \$PATH"
