#!/usr/bin/env bash
# https://github.com/complexorganizations/linux-automatic-updates

# Require script to be run as root
function super_user_check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "Error: You need to run this script as administrator."
    exit
  fi
}

# Check for root
super_user_check

# Get the current system information
function system_information() {
  if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    CURRENT_DISTRO=${ID}
  fi
}

# Get the current system information
system_information

# Validate if the system is supported
function check_supported_distro() {
  # Supported distributions
  SUPPORTED_DISTROS=("ubuntu" "debian" "raspbian" "pop" "kali" "linuxmint" "neon"
    "fedora" "centos" "rhel" "almalinux" "rocky" "arch" "archarm"
    "manjaro" "alpine" "freebsd" "ol" "opensuse" "sles")
  # Check if the current distribution is supported
  if [[ ! ${SUPPORTED_DISTROS[*]} =~ ${CURRENT_DISTRO} ]]; then
    # If the distribution is not supported, exit the script
    echo "Error: ${CURRENT_DISTRO} is not supported."
    # Exit the script
    exit 1
  fi
}

# Run the check for supported distributions
check_supported_distro

# Update linux completely.
function update_linux_completely() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get clean -y
    apt-get autoremove -y
    apt-get autoclean -y
    apt-get install unattended-upgrades -y
  elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "ol" ]; }; then
    dnf update -y
    dnf upgrade -y
    dnf clean all
    dnf autoremove -y
  elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
    pacman -Syu --noconfirm
    pacman -Sc --noconfirm
  elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
    apk update
    apk upgrade --available
  elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
    pkg update
    pkg upgrade -y
  elif { [ "${CURRENT_DISTRO}" == "opensuse" ] || [ "${CURRENT_DISTRO}" == "sles" ]; }; then
    zypper refresh
    zypper update -y
  fi
}

# Completely update linux
update_linux_completely

# Function to setup auto updates on linux to update each day
function setup_auto_updates() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "ol" ]; }; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  elif { [ "${CURRENT_DISTRO}" == "opensuse" ] || [ "${CURRENT_DISTRO}" == "sles" ]; }; then
    echo "Setting up auto updates for ${CURRENT_DISTRO}"
  fi
}

# Setup auto updates
setup_auto_updates
