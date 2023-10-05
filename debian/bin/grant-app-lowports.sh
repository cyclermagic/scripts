#!/bin/bash
# Allows the specified binary file to bind to low port numbers (i.e. <1024)
BINARY_FILE=$1
if [ ! -f "${BINARY_FILE}" ]; then
    echo "No binary file specified"
    exit 1
fi

sudo setcap CAP_NET_BIND_SERVICE=+eip ${BINARY_FILE}
echo "Please restart any services using ${BINARY_FILE}"