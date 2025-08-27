#!/bin/sh
# Simple voucher generator for Nodogsplash
# Usage: genvoucher.sh <seconds> <price>

VOUCHER_FILE="/etc/nds/vouchers.txt"

[ $# -lt 2 ] && {
  echo "Usage: $0 <timeout_seconds> <price>"
  exit 1
}

TIMEOUT="$1"
PRICE="$2"

# Generate random code (8 chars alphanumeric)
CODE=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c8)

# Save to voucher file
echo "$CODE|$TIMEOUT|$PRICE" >> "$VOUCHER_FILE"

echo "Generated voucher:"
echo "  Code:    $CODE"
echo "  Timeout: $TIMEOUT seconds"
echo "  Price:   $PRICE"
