#!/bin/bash

# Set up
CHUNK_SIZE=100
WORK_DIR="/tmp/install-everything"
PKG_LIST="$WORK_DIR/all-packages.txt"
CHUNK_PREFIX="$WORK_DIR/pkg_chunk_"
LOG_SUCCESS="$WORK_DIR/success.log"
LOG_FAIL="$WORK_DIR/fail.log"

mkdir -p "$WORK_DIR"
touch "$LOG_SUCCESS" "$LOG_FAIL"

echo "[*] Updating package list..."
sudo apt update

echo "[*] Generating full package list..."
apt-cache pkgnames | sort -u > "$PKG_LIST"

echo "[*] Filtering out already installed packages..."
comm -23 "$PKG_LIST" <(dpkg -l | awk '{print $2}' | sort -u) > "$PKG_LIST.filtered"

echo "[*] Splitting package list into chunks of $CHUNK_SIZE..."
split -l $CHUNK_SIZE "$PKG_LIST.filtered" "$CHUNK_PREFIX"

echo "[*] Starting install loop..."
for file in "$CHUNK_PREFIX"*; do
    echo "[+] Installing chunk: $file"
    while read -r pkg; do
        # Skip if already installed
        dpkg -s "$pkg" &> /dev/null && continue

        echo "[>] Installing $pkg"
        if sudo apt install -y "$pkg"; then
            echo "$pkg" >> "$LOG_SUCCESS"
        else
            echo "$pkg" >> "$LOG_FAIL"
        fi
    done < "$file"
done

echo ""
echo "🎉 Done! Installed packages are logged in:"
echo "  - Success: $LOG_SUCCESS"
echo "  - Failures: $LOG_FAIL"
