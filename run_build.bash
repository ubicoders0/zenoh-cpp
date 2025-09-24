#!/usr/bin/env bash
set -euo pipefail

# ===== Paths =====
ZENOH_CPP_SRC="."      # assume script runs from zenoh-cpp source root
ZENOH_CPP_BUILD="build/linux-x64"

# ===== Clean stale cache =====
rm -rf "$ZENOH_CPP_BUILD"

# ===== Configure =====
cmake -S "$ZENOH_CPP_SRC" -B "$ZENOH_CPP_BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DZENOHCXX_ZENOHC=ON \
  -DZENOHCXX_ZENOHPICO=OFF \
  -DZENOHCXX_ENABLE_TESTS=OFF \
  -DZENOHCXX_ENABLE_EXAMPLES=ON

# ===== Build =====
cmake --build "$ZENOH_CPP_BUILD" -j"$(nproc)"

# ===== Install (default → /usr/local) =====
sudo cmake --install "$ZENOH_CPP_BUILD"

echo
echo "Installed zenoh-cpp to: /usr/local"
echo "  - Headers:   /usr/local/include"
echo "  - Libraries: /usr/local/lib"
echo "  - Binaries:  /usr/local/bin"
