#!/usr/bin/env bash
# Linux only

CHECKOUT_ROOT="${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}"
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
NODE_EXPORTER_HOME="${NODE_EXPORTER_HOME:-${HOME}/apps/node_exporter}"
VERSION="${NODE_EXPORTER_VERSION:-1.2.2}"
OS="${NODE_EXPORTER_OS:-$(get_running_os)}"
ARCHITECTURE="${NODE_EXPORTER_ARCHITECTURE:-amd64}"

DEFAULT_DIR="node_exporter-$VERSION.$OS-$ARCHITECTURE"
TAR_GZ_FNAME="$DEFAULT_DIR.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/node_exporter/releases/download/v$VERSION/$TAR_GZ_FNAME"
echo "node_exporter home is: $NODE_EXPORTER_HOME"
echo "Download URL is: $DOWNLOAD_URL"

ORIGINAL_DIR=$(pwd)
mkdir -p "$NODE_EXPORTER_HOME"
cd "$NODE_EXPORTER_HOME" || exit 1

# Download
curl -LO "$DOWNLOAD_URL"
# Uncompress
tar -xvf "$TAR_GZ_FNAME"
# Move files out to NODE_EXPORTER_HOME and get rid of long name
mv "$DEFAULT_DIR"/* .
rm -rf "$DEFAULT_DIR"

cd "$ORIGINAL_DIR" || exit 1
echo "---------------------- INSTALLED NODE_EXPORTER ----------------------"
"$NODE_EXPORTER_HOME"/node_exporter --version
echo "------------------------------------------------------------------"
echo "Please add '$NODE_EXPORTER_HOME' to your \$PATH"
