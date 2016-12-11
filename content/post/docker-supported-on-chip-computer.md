+++
Categories = ["Docker", "Raspberry Pi", "ARM", "CHIP", "NextThingCo"]
Tags = ["Docker", "Raspberry Pi", "ARM", "CHIP", "NextThingCo"]
date = "2016-12-11T13:22:15+01:00"
draft = false
more_link = "yes"
title = "Docker is supported on the $9 C.H.I.P. computer"

+++

I guess you're already knowing, one of the cheapest but powerful ARM boards is the $9 C.H.I.P. computer from Next Thing Co. [@NextThingCo](https://twitter.com/nextthingco). It has an ARMv7 1GHz CPU with 512 MByte of main memory, 4 GByte flash memory as disk storage and is equipped with onboard WiFi and bluetooth as well.
![chip-photo](/images/install-docker-on-chip-computer/chip-photo2.jpg)

Some time ago I wrote a detailed blog post about how to [Install Docker 1.12 on the $9 C.H.I.P. computer](http://blog.hypriot.com/post/install-docker-on-chip-computer/) with the help of a custom Linux kernel which I built from source for this purpose and included all the necessary kernel modules which are required to run Docker. As an outlook I mentioned that one of the kernel developers from [@NextThingCo](https://twitter.com/nextthingco), namely Wynter Woods [@zerotri](https://twitter.com/zerotri), is working to support Docker officially.

Kernel development and testing takes time and finally here it is!<br>
**Docker is running on the C.H.I.P. with their latest standard kernel!**

<!--more-->
![chip-and-banana](/images/install-docker-on-chip-computer/chip-and-banana.jpg)

### Short overview

With the new Docker-enabled Linux kernel for the C.H.I.P. it's really easy to install and use Docker on these tiny cute ARM devices. Basically you just have to update/upgrade to the latest software packages through the standard `apt` package management commands, have to install Docker and you're good to go.

As I've already covered all these steps in detail in my post [Install Docker 1.12 on the $9 C.H.I.P. computer](http://blog.hypriot.com/post/install-docker-on-chip-computer/), we can take a shortcut and I'm explaining only the new and shorter steps.

### Necessary steps to install Docker

1. Flash the latest available firmware (see [last post](http://blog.hypriot.com/post/install-docker-on-chip-computer/))
2. Connect to the C.H.I.P. via USB or UART console cable (see [last post](http://blog.hypriot.com/post/install-docker-on-chip-computer/))
3. Configure WiFi connection (see [last post](http://blog.hypriot.com/post/install-docker-on-chip-computer/))
4. Configure SSH to access the C.H.I.P. (see [last post](http://blog.hypriot.com/post/install-docker-on-chip-computer/))
5. Checking the OS and Linux kernel version
6. Upgrade the Linux kernel and operating system
7. Install the Docker Engine the official way
8. Run your first Docker Container on the C.H.I.P.

#### Step 5: Checking the OS and Linux kernel version

Here I've flashed the C.H.I.P. with the latest available firmware
```
uname -a
Linux chip 4.4.13-ntc-mlc #1 SMP Thu Nov 3 01:28:54 UTC 2016 armv7l GNU/Linux
```
and we can see it's running a Linux kernel version `4.4.13-ntc-mlc` which is compiled at `Thu Nov 3 01:28:54 UTC 2016`. If you've flashed your device weeks or months before, you could maybe see a different and older kernel version.

#### Step 6: Upgrade the Linux kernel and operating system

The new Docker-enabled Linux kernel for the C.H.I.P. computer is already available in the standard APT package repository, but it's not yet included in the latest firmware you can flash with the [C.H.I.P. Flasher](http://flash.getchip.com/).

In order to update/upgrade the C.H.I.P. kernel we are going the easy way and performing a complete update and upgrade process of the operating system as well.
```
apt-get update
apt-get upgrade
```
As you can see on the `apt-get upgrade` command, you'll be asked to confirm to install a few new software packages which also includes the new kernel packages.
```
...
The following packages will be upgraded:
  apt apt-utils base-files chip-mali-modules-4.4.13-ntc-mlc cpio dmsetup dpkg e2fslibs e2fsprogs
  gnupg gpgv libapt-inst1.5 libapt-pkg4.12 libc-bin libc6 libcomerr2 libdevmapper1.02.1
  libdns-export100 libgcrypt20 libhogweed2 libicu52 libidn11 libirs-export91 libisc-export95
  libisccfg-export90 libnettle4 libpam-modules libpam-modules-bin libpam0g libpcre3 libss2
  libtasn1-6 libudev1 linux-image-4.4.13-ntc-mlc multiarch-support
  rtl8723bs-mp-driver-modules-4.4.13-ntc-mlc tar tzdata udev vim-common vim-tiny wget
42 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 39.8 MB of archives.
After this operation, 8562 kB of additional disk space will be used.
Do you want to continue? [Y/n]
```

At the end of the upgrade you have to reboot the device in order to boot the new Linux kernel. That's all, really!
```
reboot
```

As you log in again, you can see
```
uname -a
Linux chip 4.4.13-ntc-mlc #1 SMP Tue Dec 6 21:38:00 UTC 2016 armv7l GNU/Linux
```
the new Linux kernel has the same version, but a newer build time from `Tue Dec 6 21:38:00 UTC 2016`.

#### Step 6: Install the Docker Engine the official way

To install Docker the official way is quite easy today because we can use the APT packages and install scripts directly provided by the [Docker project](https://github.com/docker/docker). And Debian for ARMv7 is one of the officially supported OS.

```
curl -sSL https://get.docker.com | sh
```
This will take some time, but after a while the Docker Engine is installed on your C.H.I.P. computer with just a few commands.

```
root@chip:~# cat /etc/apt/sources.list.d/docker.list
deb [arch=armhf] https://apt.dockerproject.org/repo debian-jessie main
```

Check the version of the Docker client command.
```
root@chip:~# docker --version
Docker version 1.12.2, build bb80604
```

Check the versions of the Docker client, Docker API and Docker Engine.
```
root@chip:~# docker version
Client:
 Version:      1.12.2
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   bb80604
 Built:        Tue Oct 11 17:52:51 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.12.2
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   bb80604
 Built:        Tue Oct 11 17:52:51 2016
 OS/Arch:      linux/arm
```

Get some more details about the running Docker Engine.
```
root@chip:~# docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.12.2
Storage Driver: devicemapper
 Pool Name: docker-0:16-33578-pool
 Pool Blocksize: 65.54 kB
 Base Device Size: 10.74 GB
 Backing Filesystem: ext4
 Data file: /dev/loop0
 Metadata file: /dev/loop1
 Data Space Used: 305.7 MB
 Data Space Total: 107.4 GB
 Data Space Available: 6.596 GB
 Metadata Space Used: 729.1 kB
 Metadata Space Total: 2.147 GB
 Metadata Space Available: 2.147 GB
 Thin Pool Minimum Free Space: 10.74 GB
 Udev Sync Supported: true
 Deferred Removal Enabled: false
 Deferred Deletion Enabled: false
 Deferred Deleted Device Count: 0
 Data loop file: /var/lib/docker/devicemapper/devicemapper/data
 WARNING: Usage of loopback devices is strongly discouraged for production use. Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
 Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata
 Library Version: 1.02.90 (2014-09-01)
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: overlay bridge null host
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Security Options:
Kernel Version: 4.4.13-ntc-mlc
Operating System: Debian GNU/Linux 8 (jessie)
OSType: linux
Architecture: armv7l
CPUs: 1
Total Memory: 491 MiB
Name: chip
ID: Z7U2:2DYF:G54F:2QLU:AAG3:TD7Y:YWSQ:6PRM:6ZW3:WIC5:7DEA:HFFK
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No swap limit support
WARNING: No kernel memory limit support
Insecure Registries:
 127.0.0.0/8
```

Finally we could see, the latest Docker Engine v1.12.2 for Debian/ARMv7 is now installed and is successfully running.

#### Step 8: Run your first Docker Container on the C.H.I.P.

As a last step we'd like to start a first Docker container, a small web server.
```
docker run -d -p 80:80 hypriot/rpi-busybox-httpd
Unable to find image 'hypriot/rpi-busybox-httpd:latest' locally
latest: Pulling from hypriot/rpi-busybox-httpd
c74a9c6a645f: Pull complete
6f1938f6d8ae: Pull complete
e1347d4747a6: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:c00342f952d97628bf5dda457d3b409c37df687c859df82b9424f61264f54cd1
Status: Downloaded newer image for hypriot/rpi-busybox-httpd:latest
fec2773baaec570ba8b6e00296dfd11b4b4768d1b51e574d851968b9225b9d22
```

Now start your web browser and point it to the website from our Docker container.
```
open http://192.168.2.112
```

![first-container-on-chip](/images/install-docker-on-chip-computer/first-container-on-chip.jpg)

### Using latest RC of Docker Engine

If you'd like to get the latest Docker Engine for testing, like release candidates, you can install it pretty easily with
```
curl -sSL https://test.docker.com | sh
```
Or you can upgrade your current system with
```
#edit /etc/apt/sources.list.d/docker.list # change 'main' to 'testing'
cat /etc/apt/sources.list.d/docker.list
deb [arch=armhf] https://apt.dockerproject.org/repo debian-jessie testing

apt-get update
apt-get install -y docker-engine
```

Now you can test the latest available release candidate of the Docker Engine with all the newest features with Docker Swarm mode and other goodies.
```
docker version
Client:
 Version:      1.13.0-rc3
 API version:  1.25
 Go version:   go1.7.3
 Git commit:   4d92237
 Built:        Mon Dec  5 19:00:08 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.13.0-rc3
 API version:  1.25 (minimum version 1.12)
 Go version:   go1.7.3
 Git commit:   4d92237
 Built:        Mon Dec  5 19:00:08 2016
 OS/Arch:      linux/arm
 Experimental: false
```


### TL;DR - Install Docker on the C.H.I.P. computer

For all the impatient users, these are the minimal steps to install the latest Linux kernel and the latest Docker Engine on the C.H.I.P. computer.
```
apt-get update
apt-get upgrade -y
reboot
curl -sSL https://get.docker.com | sh
```

DONE !!!!

### Acknowledgments

Again, I like to thank Wynter Woods [@zerotri](https://twitter.com/zerotri) from [@NextThingCo](https://twitter.com/nextthingco) for his efforts and hard work to include all the Linux kernel changes necessary to run the Docker Engine pretty slick on the C.H.I.P. computer. It's so great to see when all the changes will be accepted and implemented in the upstream version, so everybody can use the new features without spending too much time.

That's the important point to work in opensource, contributing back so that all users benefit from the results!

### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
