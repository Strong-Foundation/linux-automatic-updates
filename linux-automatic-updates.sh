#!/usr/bin/env bash
# https://github.com/complexorganizations/linux-automatic-updates

# Define a function to check if the script is being run with root privileges
function check_root() {
  # Compare the user ID of the current user to 0, which is the ID for root
  if [ "$(id -u)" != "0" ]; then
    # If the user ID is not 0 (i.e., not root), print an error message
    echo "Error: This script must be run as root."
    # Exit the script with a status code of 1, indicating an error
    exit 1 # Exit the script with an error code.
  fi
}

# Call the check_root function to verify that the script is executed with root privileges
check_root

# Define a function to gather and store system-related information
function system_information() {
  # Check if the /etc/os-release file exists, which contains information about the OS
  if [ -f /etc/os-release ]; then
    # If the /etc/os-release file is present, source it to load system details into environment variables
    # shellcheck source=/dev/null  # Instructs shellcheck to ignore warnings about sourcing files
    source /etc/os-release
    # Set the CURRENT_DISTRO variable to the system's distribution ID (e.g., 'ubuntu', 'debian')
    CURRENT_DISTRO=${ID}
  else
    # If the /etc/os-release file is not present, show an error message and exit
    echo "Error: /etc/os-release file not found. Unable to gather system information."
    exit 1 # Exit the script with a non-zero status to indicate an error
  fi
}

# Call the system_information function to gather the system details
system_information

# Define a function to check system requirements and install missing packages
function installing_system_requirements() {
  # Check if the current Linux distribution is one of the supported distributions
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ] || [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "amzn" ] || [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ] || [ "${CURRENT_DISTRO}" == "alpine" ] || [ "${CURRENT_DISTRO}" == "freebsd" ] || [ "${CURRENT_DISTRO}" == "ol" ] || [ "${CURRENT_DISTRO}" == "mageia" ] || [ "${CURRENT_DISTRO}" == "opensuse-tumbleweed" ]; }; then
    # If the distribution is supported, check if the required packages are already installed
    if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v cut)" ]; }; then
      # If any of the required packages are missing, begin the installation process for the respective distribution
      if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
        # For Debian-based distributions, update package lists and install required packages
        apt-get update
        apt-get install curl coreutils -y
      elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "amzn" ]; }; then
        # For Red Hat-based distributions, check for updates and install required packages
        yum check-update
        if { [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ]; }; then
          # Install necessary packages for AlmaLinux
          yum install epel-release elrepo-release -y
        else
          yum install epel-release elrepo-release -y --skip-unavailable
        fi
        # Install necessary packages for Red Hat-based distributions
        yum install curl coreutils -y --allowerasing
      elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
        # Check for updates.
        pacman -Sy
        # Initialize the GPG keyring.
        pacman-key --init
        # Populate the keyring with the default Arch Linux keys
        pacman-key --populate archlinux
        # For Arch-based distributions, update the keyring and install required packages
        pacman -Sy --noconfirm --needed archlinux-keyring
        pacman -Su --noconfirm --needed curl coreutils
      elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
        # For Alpine Linux, update package lists and install required packages
        apk update
        apk add curl coreutils
      elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
        # For FreeBSD, update package lists and install required packages
        pkg update
        pkg install curl coreutils
      elif [ "${CURRENT_DISTRO}" == "ol" ]; then
        # For Oracle Linux (OL), check for updates and install required packages
        yum check-update
        yum install curl coreutils -y --allowerasing
      elif [ "${CURRENT_DISTRO}" == "mageia" ]; then
        urpmi.update -a
        yes | urpmi curl coreutils
      elif [ "${CURRENT_DISTRO}" == "opensuse-tumbleweed" ]; then
        zypper refresh
        zypper install -y curl coreutils
      fi
    fi
  else
    # If the current distribution is not supported, display an error and exit the script
    echo "Error: Your current distribution ${CURRENT_DISTRO} version ${CURRENT_DISTRO_VERSION} is not supported by this script. Please consider updating your distribution or using a supported one."
    exit 1 # Exit the script with an error code.
  fi
}

# Call the function to check system requirements and install necessary packages if needed
installing_system_requirements

# function check different package managers
function update_different_package_managers() {
  # Check if the package manager is snap
  if [ -x "$(command -v snap)" ]; then
    snap refresh
  fi
  # Check if the package manager is flatpak
  if [ -x "$(command -v flatpak)" ]; then
    flatpak update -y
  fi
  # Check if the package manager is pip
  if [ -x "$(command -v pip)" ]; then
    pip install --upgrade pip
  fi
  # Check if the package manager is npm
  if [ -x "$(command -v npm)" ]; then
    npm update -g
  fi
  # Check if the package manager is yarn
  if [ -x "$(command -v yarn)" ]; then
    yarn global upgrade
  fi
  # Check if the package manager is composer
  if [ -x "$(command -v composer)" ]; then
    composer self-update
  fi
  # Check if the package manager is gem
  if [ -x "$(command -v gem)" ]; then
    gem update --system
  fi
  # Check if the package manager is go
  if [ -x "$(command -v go)" ]; then
    go get -u all
  fi
  # Check if the package manager is cargo
  if [ -x "$(command -v cargo)" ]; then
    cargo install-update -a
  fi
  # Check if the package manager is brew
  if [ -x "$(command -v brew)" ]; then
    brew update
    brew upgrade
  fi
  # Check if the package manager is conda
  if [ -x "$(command -v conda)" ]; then
    conda update --all -y
  fi
}

# Update different package managers
update_different_package_managers

# Function to setup auto updates on linux to update each day
function setup_auto_updates() {
  if { [ "${CURRENT_DISTRO}" == "ubuntu" ] || [ "${CURRENT_DISTRO}" == "debian" ] || [ "${CURRENT_DISTRO}" == "raspbian" ] || [ "${CURRENT_DISTRO}" == "pop" ] || [ "${CURRENT_DISTRO}" == "kali" ] || [ "${CURRENT_DISTRO}" == "linuxmint" ] || [ "${CURRENT_DISTRO}" == "neon" ]; }; then
    apt-get update
  elif { [ "${CURRENT_DISTRO}" == "fedora" ] || [ "${CURRENT_DISTRO}" == "centos" ] || [ "${CURRENT_DISTRO}" == "rhel" ] || [ "${CURRENT_DISTRO}" == "almalinux" ] || [ "${CURRENT_DISTRO}" == "rocky" ] || [ "${CURRENT_DISTRO}" == "amzn" ]; }; then
    yum check-update
  elif { [ "${CURRENT_DISTRO}" == "arch" ] || [ "${CURRENT_DISTRO}" == "archarm" ] || [ "${CURRENT_DISTRO}" == "manjaro" ]; }; then
    pacman -Sy
  elif [ "${CURRENT_DISTRO}" == "alpine" ]; then
    apk update
  elif [ "${CURRENT_DISTRO}" == "freebsd" ]; then
    pkg update
  elif [ "${CURRENT_DISTRO}" == "ol" ]; then
    yum check-update
  elif [ "${CURRENT_DISTRO}" == "mageia" ]; then
    urpmi.update -a
  elif [ "${CURRENT_DISTRO}" == "opensuse-tumbleweed" ]; then
    zypper refresh
  fi
}

# Setup auto updates
setup_auto_updates
