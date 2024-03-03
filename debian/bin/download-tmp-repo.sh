#!/bin/bash
REPO_TMP_DIR="/tmp/cyclermagic-scripts.$(date +%y%m%dd%H%M%S)"
UNZIPPED_DIR_NAME="scripts-main"

/usr/bin/wget https://github.com/cyclermagic/scripts/archive/refs/heads/main.zip
/usr/bin/unzip main.zip

mv ${UNZIPPED_DIR_NAME}/* ${REPO_TMP_DIR}/
cd ${REPO_TMP_DIR}/${UNZIPPED_DIR_NAME}

echo "${REPO_TMP_DIR}"
