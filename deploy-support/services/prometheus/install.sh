#!/usr/bin/env bash

CHECKOUT_ROOT=$(realpath "${CHECKOUT_ROOT:-$(dirname "${BASH_SOURCE[0]}")/../../..}")
# shellcheck source=lib_sh_utils/src/os.sh
source "$CHECKOUT_ROOT/lib_sh_utils/src/os.sh"

# Constants
PROMETHEUS_HOME="${PROMETHEUS_HOME:-${HOME}/apps/prometheus}"
VERSION="${PROMETHEUS_VERSION:-2.30.0}"
OS="${PROMETHEUS_OS:-$(get_running_os)}"
ARCHITECTURE="${PROMETHEUS_ARCHITECTURE:-amd64}"

DEFAULT_DIR="prometheus-$VERSION.$OS-$ARCHITECTURE"
TAR_GZ_FNAME="$DEFAULT_DIR.tar.gz"
DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v$VERSION/$TAR_GZ_FNAME"
echo "Prometheus home is: $PROMETHEUS_HOME"
echo "Download URL is: $DOWNLOAD_URL"

ORIGINAL_DIR=$(pwd)
mkdir -p "$PROMETHEUS_HOME"
cd "$PROMETHEUS_HOME" || exit 1

# Download
curl -LO "$DOWNLOAD_URL"
# Uncompress
tar -xvf "$TAR_GZ_FNAME"
# Move files out to PROMETHEUS_HOME and get rid of long name
mv "$DEFAULT_DIR"/* .
rm -rf "$DEFAULT_DIR"

cd "$ORIGINAL_DIR" || exit 1
echo "---------------------- INSTALLED PROMETHEUS ----------------------"
"$PROMETHEUS_HOME"/prometheus --version
echo "------------------------------------------------------------------"
echo "Please add '$PROMETHEUS_HOME' to your \$PATH"
