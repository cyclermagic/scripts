#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
set -x

SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

source "${SCRIPT_DIR}/_default.sh"
source "${SCRIPT_DIR}/security/security.standard.sh"
echo "=== DONE ==="