#!/usr/bin/env bash

# Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as super user."
    exit
  fi
}

# Check for root
super-user-check

# Detect Operating System
function dist-check() {
  if [ -e /etc/os-release ]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    DISTRO=${ID}
    CURRENT_DISTRO_VERSION=${VERSION_ID}
  fi
}

# Check Operating System
dist-check

# Pre-Checks system requirements
function installing-system-requirements() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ] || [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ] || [ "${CURRENT_DISTRO}" == "alpine" ] || [ "${CURRENT_DISTRO}" == "freebsd" ]; }; then
    if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v cron)" ]; }; then
      if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
        apt-get update
        apt-get install curl cron -y
      elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ]; }; then
        yum update -y
        yum install curl cronie -y
      elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
        pacman -Syu
        pacman -Syu --noconfirm curl cronie
      elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
        apk update
        yum install curl cronie -y
      elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
        pkg update
        pkg install curl cronie
      fi
    fi
  else
    echo "Error: ${CURRENT_DISTRO} ${CURRENT_DISTRO_VERSION} is not supported."
    exit
  fi
}

# Run the function and check for requirements
installing-system-requirements

# Global Variables
CURRENT_FILE_PATH="$(realpath "${0}")"

# Usage guide for the script
function usage-guide-for-script() {
  echo "usage: ./${CURRENT_FILE_PATH} <command>"
  echo "--update-script    Update your local script with the latest version from github."
  echo "--update-os        Start WireGuard"
  echo "--install-cron     Stop WireGuard"
}

# Update linux completely.
function update-linux-completely() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get install -f -y
    apt-get clean -y
    apt-get autoclean -y
    apt-get autoremove --purge -y
  elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ]; }; then
    yum update -y
    yum upgrade -y
    yum autoremove -y
    yum clean all -y
  elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
    pacman -Syu
  elif [ "${DISTRO}" == "alpine" ]; then
    apk update
    apk upgrade
  elif [ "${DISTRO}" == "freebsd" ]; then
    pkg update
    pkg upgrade
  fi
}

# Completely update linux
update-linux-completely

# Install cron service.
function install-cron-service() {
  crontab -l | {
    cat
    echo "0 0 * * * ${CURRENT_FILE_PATH}"
  } | crontab -
  if [ -x "$(command -v service)" ]; then
    service cron enable
    service cron start
  elif [ -x "$(command -v systemctl)" ]; then
    systemctl enable cron
    systemctl start cron
  fi
}

function update-local-script-to-latest() {
  case $(shuf -i 1-5 -n 1) in
  1)
    LINUX_AUTOMATIC_UPDATE_URL="https://raw.githubusercontent.com/complexorganizations/linux-automatic-updates/main/linux-manager.sh"
    ;;
  2)
    LINUX_AUTOMATIC_UPDATE_URL="https://cdn.statically.io/gh/complexorganizations/linux-automatic-updates/main/linux-automatic-updates.sh"
    ;;
  3)
    LINUX_AUTOMATIC_UPDATE_URL="https://cdn.jsdelivr.net/gh/complexorganizations/linux-automatic-updates/linux-automatic-updates.sh"
    ;;
  4)
    LINUX_AUTOMATIC_UPDATE_URL="https://gitcdn.link/cdn/complexorganizations/linux-automatic-updates/main/linux-automatic-updates.sh"
    ;;
  5)
    LINUX_AUTOMATIC_UPDATE_URL="https://combinatronics.io/complexorganizations/linux-automatic-updates/main/linux-automatic-updates.sh"
    ;;
  esac
  curl ${LINUX_AUTOMATIC_UPDATE_URL} -o ${CURRENT_FILE_PATH}
  chmod +x "${CURRENT_FILE_PATH}"
}
