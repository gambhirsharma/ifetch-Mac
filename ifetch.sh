#!/bin/sh

# Parsing SystemVersion.plist for macOS information
PRODUCT_NAME=$(defaults read /System/Library/CoreServices/SystemVersion.plist ProductName)
PRODUCT_VERSION=$(defaults read /System/Library/CoreServices/SystemVersion.plist ProductVersion)
ID=$(echo "$PRODUCT_NAME" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

BLACK='[0;30m'
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[0;33m'
BLUE='[0;34m'
PURPLE='[0;35m'
CYAN='[0;36m'
WHITE='[0;37m'
RESET='[0m'

PID=$(($RANDOM % 808 + 1))
SPRITE=$(cat "$(dirname $0)/colorscripts/${PID}" | sed -e 's/$/[0m/g')

HOST_NAME=$(hostname)
KERNEL_VERSION=$(uname -r)
MEMORY_STATS=$(sysctl hw.memsize | awk '{print $2}')
TOTAL_MEMORY=$((MEMORY_STATS / 1024 / 1024))
USAGE_MEMORY=$(top -l 1 | awk '/PhysMem/ {print $2}' | tr -d 'MB')

out=$(
cat << EOF
# ${PURPLE}$USER@$HOSTNAME${RESET}
├─ ${BLUE}os${RESET}: $ID
├─ ${BLUE}host${RESET}: $HOST_NAME $PRODUCT_VERSION
├─ ${BLUE}kernel${RESET}: $KERNEL_VERSION
├─ ${BLUE}memory${RESET}: ${USAGE_MEMORY}/${TOTAL_MEMORY} Mib
└─ $COLOR
EOF
)

out=$(gum style --margin "0 2" "${out}")
out=$(gum join --align center --horizontal "${SPRITE}" "${out}")
out=$(gum style --margin "0 2" "${out}")

echo "${out}"
