#!/bin/bash
LOCALMAIL_USERNAME=$1
if [ -z "${LOCALMAIL_USERNAME}" ]; then
    echo "Exiting: Empty param 1 (LOCALMAIL_USERNAME)" 
    exit 1
fi

# NTP source name (prefix used in .sources file name)
NTP_SOURCE_NAME=$2
if [ -z "${NTP_SOURCE_NAME}" ]; then
    echo "Exiting: Empty param 2 (NTP_SOURCE_NAME)" 
    exit 1
fi

# Space-delimited NTP Server IPs/ Hostnames
# Example: 10.0.0.1 10.0.0.2 10.0.0.3
NTP_SERVERS=$3
if [ -z "${NTP_SERVERS}" ]; then
    echo "Exiting: Empty param 3 (NTP_SERVERS)" 
    exit 1
fi

# Drivers/ Firmware
apt-get -y install firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-amd-graphics firmware-realtek

# Utilities
apt-get -y install dnsutils

# Enable periodic TRIM
systemctl enable --now fstrim.timer

# Install ntp
echo "> Configuring NTP..."
apt-get -y remove ntp
apt-get -y install chrony

NTP_SRC_FILE="/etc/chrony/sources.d/${NTP_SOURCE_NAME}.sources"
echo "" > ${NTP_SRC_FILE}
for ntpServer in ${NTP_SERVERS} # note that $var must NOT be quoted here!
do
   echo "server $ntpServer iburst" >> ${NTP_SRC_FILE}
done

service chrony force-reload

# Enable auto-upgrades
echo "> Enabling auto-upgrades..."

apt-get -y install unattended-upgrades apt-listchanges apt-listbugs
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

# Enable upgrade mail notifications
# todo: Fix and test ${LOCALMAIL_USERNAME}
# sed -i 's/#Unattended-Upgrade::Mail "";/#Unattended-Upgrade::Mail "${LOCALMAIL_USERNAME}";/g' /etc/apt/apt.conf.d/50unattended-upgrades

# Configure MOTD
echo "> Updating MOTD Scripts..."

SCRIPTS_HTTP_SRC="https://raw.githubusercontent.com/cyclermagic/scripts/main/debian/etc/update-motd.d/"
SCRIPTS_DIR="/etc/update-motd.d"
CURL_TIMEOUT_SECS=3

curl -XGET "${SCRIPTS_HTTP_SRC}/check-lts" -L -s --connect-timeout ${CURL_TIMEOUT_SECS} --max-time ${CURL_TIMEOUT_SECS} -o "${SCRIPTS_DIR}/20-check-lts"
chmod +x "${SCRIPTS_DIR}/20-check-lts"

#!/bin/bash
apt-get update

# Install Power Management packages
echo "====================================="
echo "Updating Power Management packages..."
echo "====================================="
apt-get -y install linux-cpupower linux-perf tlp
