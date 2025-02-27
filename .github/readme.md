### Linux Automatic Updates

Automatically update linux.


### Apt
```
echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list
apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get clean -y && apt-get autoremove -y && apt-get autoclean -y && apt-get install -f -y
```

### Dnf
```
dnf update -y && dnf upgrade -y && dnf clean all && dnf autoremove -y && dnf install -y
```

---
### Author

---	
### Credits
Open Source Community

---
### License
This project is unlicensed.
