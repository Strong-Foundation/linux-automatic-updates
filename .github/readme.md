# Linux Automatic Updates

## Overview

Automate the process of keeping your Linux system up-to-date with the latest security patches and software upgrades. This script provides commands for **APT** (Debian-based systems), **DNF** (Fedora-based systems), **Pacman** (Arch-based systems), and **Zypper** (openSUSE-based systems) to ensure a smooth and automated update process.

## Installation & Usage

### For APT-based Systems (Debian, Ubuntu)

To automatically update your Debian-based system, run the following command:

```sh
echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get clean -y && apt-get autoremove -y && apt-get autoclean -y && apt-get install -f -y
```

### For DNF-based Systems (Fedora, RHEL, CentOS)

For Fedora-based distributions, use the following command:

```sh
dnf update -y && dnf upgrade -y && dnf clean all && dnf autoremove -y && dnf install -y
```

### For Pacman-based Systems (Arch, Manjaro)

To update an Arch-based system, use the following command:

```sh
pacman -Syu --noconfirm && pacman -Sc --noconfirm && pacman -Rns $(pacman -Qdtq) --noconfirm
```

### For Zypper-based Systems (openSUSE)

For openSUSE-based distributions, use:

```sh
zypper refresh && zypper update -y && zypper clean -a
```

## Automation

To enable automatic updates, you can schedule these commands using **cron jobs** or **systemd timers**. Here’s an example of setting up a cron job:

```sh
sudo crontab -e
```

Add the following line to run updates daily at midnight:

```sh
0 0 * * * /path/to/update-script.sh
```

Alternatively, for **systemd timers**, create a service and timer file to execute updates periodically.

## Notes

- These commands should be executed with **root** or **sudo** privileges.
- Ensure your repositories are properly configured before running updates.
- It's recommended to test updates manually before automating them.

## Contributing

Contributions are welcome! Feel free to fork this repository and submit a pull request with improvements or additional features.

## Credits

This project is maintained with support from the **Open Source Community**.

## License

This project is **unlicensed** and provided as-is, with no warranties or guarantees.
