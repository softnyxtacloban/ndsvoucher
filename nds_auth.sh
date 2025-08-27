#!/bin/sh
# Nodogsplash external auth script with one-time vouchers

METHOD="$1"
MAC="$2"

VOUCHER_FILE="/etc/nds/vouchers.txt"
USED_FILE="/etc/nds/vouchers_used.txt"

case "$METHOD" in
  auth_client)
    CODE="$3"   # User enters voucher code in username field

    [ -f "$VOUCHER_FILE" ] || exit 1

    # Look for voucher line: CODE|TIMEOUT|PRICE
    LINE=$(grep -m1 -E "^${CODE}\|" "$VOUCHER_FILE") || exit 1

    TIMEOUT=$(printf '%s' "$LINE" | cut -d'|' -f2)

    # Remove voucher from active file (consumed)
    grep -v "^${CODE}|" "$VOUCHER_FILE" > "${VOUCHER_FILE}.tmp" && mv "${VOUCHER_FILE}.tmp" "$VOUCHER_FILE"

    # Log to used vouchers
    echo "$LINE|$MAC|$(date +%s)" >> "$USED_FILE"

    # Authorize client for TIMEOUT seconds
    printf "%s 0 0\n" "$TIMEOUT"
    exit 0
    ;;

  client_auth|client_deauth|idle_deauth|timeout_deauth|ndsctl_auth|ndsctl_deauth|shutdown_deauth)
    # You can add logging here if you want session stats
    ;;
esac
