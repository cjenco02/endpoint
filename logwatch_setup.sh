#!/bin/bash

REMOTE_BASE="/var/log/remote"
LINK_DEST="/var/log"
REPORT_BASE="/var/log"

echo "🔗 Linking and generating Logwatch reports by host..."

# Loop through each host directory
for hostdir in "$REMOTE_BASE"/*; do
  [ -d "$hostdir" ] || continue

  host=$(basename "$hostdir")
  echo "🖥️  Processing host: $host"

  # Create symlinks for this host
  for logfile in "$hostdir"/*.log; do
    [ -e "$logfile" ] || continue

    base=$(basename "$logfile")
    linkname="${host}_${base}"
    target="$LINK_DEST/$linkname"

    ln -sf "$logfile" "$target"
    echo "  ✅ Linked: $target -> $logfile"
  done

  # Create a temporary Logwatch config just for this host
  tmpconf="/tmp/logwatch-${host}.conf"
  echo "LogDir = $LINK_DEST" > "$tmpconf"

  # List only this host’s logs for Logwatch
  echo -n > /tmp/logfiles-${host}.conf
  for file in "$LINK_DEST"/${host}_*.log; do
    echo "LogFile = $(basename "$file")" >> /tmp/logfiles-${host}.conf
  done

  echo "*ApplyConfig /tmp/logfiles-${host}.conf" >> "$tmpconf"

  # Run Logwatch with custom config
  report="${REPORT_BASE}/logwatch-${host}.txt"
  logwatch --config "$tmpconf" --detail high --range yesterday --service all --format text > "$report"

  echo "  📄 Logwatch report saved to $report"

  # Clean up temp files
  rm -f "$tmpconf" /tmp/logfiles-${host}.conf
done

echo "✅ All host reports generated."
