#!/bin/bash
# Credit to the following for a concise guide:
# https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-22-04
NEW_SWAP_FILE=$1

if [ -z "${NEW_SWAP_FILE}" ]; then
    echo "Exiting: New swap file was not specified"
    exit 1
fi
if [ -f "${NEW_SWAP_FILE}" ]; then
    echo "Exiting: File already exists"
    exit 1
fi

echo "Swap before:"
swapon --show

fallocate -l 1G "${NEW_SWAP_FILE}"
chmod 600 "${NEW_SWAP_FILE}"
mkswap "${NEW_SWAP_FILE}"
swapon "${NEW_SWAP_FILE}"

echo "Swap after:"
swapon --show