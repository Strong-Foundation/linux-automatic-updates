#!/usr/bin/env bash
# https://github.com/complexorganizations/linux-automatic-updates

# Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "Error: You need to run this script as administrator."
    exit
  fi
}

# Check for root
super-user-check

# Get the current system information
function system-information() {
  if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    CURRENT_DISTRO=${ID}
  fi
}

# Get the current system information
system-information

# Pre-Checks system requirements
function installing-system-requirements() {
  case ${CURRENT_DISTRO} in
    "ubuntu" | "debian" | "raspbian" | "pop" | "kali" | "linuxmint" | "neon" | "fedora" | "centos" | "rhel" | "almalinux" | "rocky" | "arch" | "archarm" | "manjaro" | "alpine" | "freebsd" | "ol") ;;
  *)
    echo "Error: ${CURRENT_DISTRO} is not supported."
    exit
    ;;
  esac
}

# Run the function and check for requirements
installing-system-requirements

# Update linux completely.
function update-linux-completely() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
    apt-get update
    apt-get install unattended-upgrades --yes
  elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "ol" ]; }; then
    yum check-update
  elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
    pacman -Sy
  elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
    apk update
  elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
    pkg update
  fi
}

# Completely update linux
update-linux-completely
