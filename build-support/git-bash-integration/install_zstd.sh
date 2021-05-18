#!/usr/bin/env bash
conda install -c conda-forge zstd -y
#curl -fsSL https://raw.githubusercontent.com/horta/zstd.install/main/install
#choco install zstandard -y
which zstd && echo "Installed zstd"
