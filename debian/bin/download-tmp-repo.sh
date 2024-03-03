#!/bin/bash
REPO_TMP_DIR="/tmp/cyclermagic-scripts.$(/usr/bin/date +%y%m%dd%H%M%S)"
UNZIPPED_DIR_NAME="scripts-main"

mkdir ${REPO_TMP_DIR}
cd ${REPO_TMP_DIR}

/usr/bin/wget -q https://github.com/cyclermagic/scripts/archive/refs/heads/main.zip
/usr/bin/unzip -q main.zip

echo $REPO_TMP_DIR/${UNZIPPED_DIR_NAME}
