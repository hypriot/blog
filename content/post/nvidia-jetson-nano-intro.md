+++
date = "2019-04-19T14:16:25+02:00"
title = "NVIDIA Jetson Nano Developer Kit - Introduction"
draft = false
more_link = "yes"
Tags = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]
Categories = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]

+++

Let me introduce the brand new **NVIDIA Jetson Nano Developer Kit**, which is basically a quad-core 64bit ARM Cortex-A57 CPU with 128 GPU cores - suitable for all kinds of maker ideas: AI, Robotics, and of course for running Docker Containers...

![Jetson-Nano-Box.jpg](/images/nvidia-jetson-nano-intro/Jetson-Nano-Box.jpg)


### Unboxing

Let's unbox the board and do the initial configuration...

<!--more-->

![Jetson-Nano-Upacked.jpg](/images/nvidia-jetson-nano-intro/Jetson-Nano-Upacked.jpg)

When opening the box we'll find the board itself and a short getting started flyer which heads us to the NVIDIA website https://NVIDIA.com/JetsonNano-Start where we can find all basic information about the new DevKit.

Please note, there are no other parts included in the DevKit. So, in order to use the DevKit you'll need some additional accessories:

* MicroSD card (at least 16GByte)
* Monitor with HDMI or DisplayPort connector
* HDMI or DisplayPort cable to connect to the monitor
* USB Keyboard and Mouse
* Micro-USB power supply (5V, 2Amps for 10 watts)


### Getting Started

Following the official documentation [Getting Started With Jetson Nano Developer Kit](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit) we have to download and flash the SD card. I don't want to repeat these basic steps here, because it's covered in great detail directy in the official NVIDIA tutorial [Write Image to the microSD Card](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#write).

When downloading the SD card image, please be aware this one isn't small at all. The download is a zipped image file of 5 GByte of compressed data.
```bash
$ ls -alh jetson-nano-sd-r32.1-2019-03-18.zip
-rw-r--r--@ 1 dieter  staff   5.3G Mar 15 22:49 jetson-nano-sd-r32.1-2019-03-18.zip 
```

The SD card image is a huge 12 GByte data blob. I would strongly recommend to use a SD card size with at least 32 GByte, with the recommended 16 GByte minimum you won't get really happy. So, please do yourself a favour and get a 32 or 64 GByte SD card.
```bash
$ ls -alh jetson-nano-sd-r32.1-2019-03-18.img
-rwxr-xr-x  1 dieter  staff    12G Mar 15 19:19 jetson-nano-sd-r32.1-2019-03-18.img
```

For flashing the SD card image you could also use the Hypriot `flash` tool, which can be found here https://github.com/hypriot/flash. That's exactly what I did from macOS.
```bash
$ flash --device /dev/disk2 jetson-nano-sd-r32.1-2019-03-18.img

Is /dev/disk2 correct? y
Unmounting /dev/disk2 ...
Unmount of all volumes on disk2 was successful
Unmount of all volumes on disk2 was successful
Flashing jetson-nano-sd-r32.1-2019-03-18.img to /dev/rdisk2 ...
Password:
12.0GiB 0:03:58 [51.6MiB/s] [=======================================================================================>] 100%
0+196608 records in
0+196608 records out
12884901888 bytes transferred in 234.213296 secs (55013537 bytes/sec)
Mounting Disk
```

Now our SD card is flashed with the latest image version, which is from March 18th 2019 as of time of this writing. But before using the SD card to boot up the NVIDIA Jetson Nano device, let's have a short look at what's on the SD card. Please, re-insert the SD card and list the current partitions. On macOS it looks like:
```bash
$ diskutil list /dev/disk2
/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *64.0 GB    disk2
   1:           Linux Filesystem                         12.9 GB    disk2s1
   2:           Linux Filesystem                         131.1 KB   disk2s2
   3:           Linux Filesystem                         458.8 KB   disk2s3
   4:           Linux Filesystem                         589.8 KB   disk2s4
   5:           Linux Filesystem                         65.5 KB    disk2s5
   6:           Linux Filesystem                         196.6 KB   disk2s6
   7:           Linux Filesystem                         589.8 KB   disk2s7
   8:           Linux Filesystem                         65.5 KB    disk2s8
   9:           Linux Filesystem                         655.4 KB   disk2s9
  10:           Linux Filesystem                         458.8 KB   disk2s10
  11:           Linux Filesystem                         131.1 KB   disk2s11
  12:           Linux Filesystem                         81.9 KB    disk2s12
  ```

OK, we'll find at least 12 different partitions from NVIDIA. Currently we don't look into all the details, maybe we can do this as part of a future blog post. For now we just know, 12 partitions are here and therefore flashing should be successful.


### Initial Configuration

For [Setup and First Boot](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#setup) of the NVIDIA Jetson Nano DevKit you need to attach a computer display, mouse and keyboard. All these steps are well documented at the NVIDIA web site, just following the prior hyperlink.

Then power up the board with the Micro-USB power supply and follow the tutorial. This procedure will take a few minutes and then you'll have a fully configured desktop system up and running which is based upon Ubuntu 18.04 LTS.


![Jetson-Nano-Board-Closeup.jpg](/images/nvidia-jetson-nano-intro/Jetson-Nano-Board-Closeup.jpg)

As I already said, the initial configuration of the Nano board has to be done interactively with the help of a computer monitor, mouse and keyboard. It's really straight forward and consists of the following steps and settings. I also did a short video of this initial setup, so it's maybe a little bit easier for you to follow.


**Settings:**

1. Accept NVIDIA End User License Agreements: YES

2. Select system language: ENGLISH

3. Select keyboard layout: ENGLISH (US)

4. Select location/timezone: BERLIN

5. Set username: pirate

6. Set computer name: jetson-nano

7. Set password: hypriot


[Here is the video link: NVIDIA-Jetson-Nano--Initial-Setup **Coming soon!**]

At the end we login with the defined username "pirate" and get this nice Ubuntu desktop on our computer monitor. Yes, it's really a fully Linux desktop system running on a 64bit ARM Cortex A57 board with 4 GByte of memory!

![jetson-desktop.jpg](/images/nvidia-jetson-nano-intro/jetson-desktop.jpg)


### Running Docker

TL;DR **Docker is running out-of-the-box on the NVIDIA Jetson Nano board!**

[Here is the video link: NVIDIA-Jetson-Nano--Running-Docker **Coming soon!**]


As soon as the Jetson Nano board is configured and attached with an ethernet network cable, we can also discover it on the network with ping. Just use the computer name you defined. Here I used `jetson-nano`, or you have to add `.local`, this depends on your router setup. But just trying both it's easy to do.
```bash
$ ping -c 3 jetson-nano
PING jetson-nano.lan (192.168.7.158): 56 data bytes
64 bytes from 192.168.7.158: icmp_seq=0 ttl=64 time=1.786 ms
64 bytes from 192.168.7.158: icmp_seq=1 ttl=64 time=1.954 ms
64 bytes from 192.168.7.158: icmp_seq=2 ttl=64 time=2.227 ms

--- jetson-nano.lan ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.786/1.989/2.227/0.182 ms
```

```bash
$ ping -c 3 jetson-nano.local
PING jetson-nano.local (192.168.7.158): 56 data bytes
64 bytes from 192.168.7.158: icmp_seq=0 ttl=64 time=1.338 ms
64 bytes from 192.168.7.158: icmp_seq=1 ttl=64 time=2.198 ms
64 bytes from 192.168.7.158: icmp_seq=2 ttl=64 time=1.964 ms

--- jetson-nano.local ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.338/1.833/2.198/0.363 ms
```

First, I'm going to check the kernel version.
```bash
pirate@jetson-nano:~$ uname -a
Linux jetson-nano 4.9.140-tegra #1 SMP PREEMPT Wed Mar 13 00:32:22 PDT 2019 aarch64 aarch64 aarch64 GNU/Linux
```

We do have a LTS 4.9 kernel available on the Jetson Nano, which is pretty OK for running Docker and Containers.

Now, let's check if there is already a Docker Engine preinstalled.
```bash
pirate@jetson-nano:~$ sudo docker version
[sudo] password for pirate:
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.1
 Git commit:        e68fc7a
 Built:             Fri Jan 25 14:35:17 2019
 OS/Arch:           linux/arm64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.1
  Git commit:       e68fc7a
  Built:            Thu Jan 24 10:49:48 2019
  OS/Arch:          linux/arm64
  Experimental:     false
```

And show what details we'll get from a `docker info` command:
```bash
pirate@jetson-nano:~$ sudo docker info
Containers: 2
 Running: 2
 Paused: 0
 Stopped: 0
Images: 1
Server Version: 18.06.1-ce
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version:  (expected: 468a545b9edcd5932818eb9de8e72413e616e86e)
runc version: N/A (expected: 69663f0bd4b60df09991c08812a60108003fa340)
init version: v0.18.0 (expected: fec3683b971d9c3ef73f284f176672c44b448662)
Security Options:
 seccomp
  Profile: default
Kernel Version: 4.9.140-tegra
Operating System: Ubuntu 18.04.2 LTS
OSType: linux
Architecture: aarch64
CPUs: 4
Total Memory: 3.868GiB
Name: jetson-nano
ID: CR66:D4BV:6TQC:GI4I:CXLP:EQMK:NK2P:FUFM:OATD:5F6M:J657:LU5T
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
```

Here is another screenshot directly from the Jetson Nano desktop with running the `docker version` command.

![jetson-desktop-docker.jpg](/images/nvidia-jetson-nano-intro/jetson-desktop-docker.jpg)


### Starting a Docker Container for ARM

Pull a first Docker Image which should run on ARM, here I'm going to use a Docker Image I did created almost four years ago for the Raspberry Pi and showcased live on stage at DockerCon 2015 in San Francisco, see [Hypriot-Demo and challenge at DockerCon 2015](https://blog.hypriot.com/post/dockercon2015/). As this is an 32bit ARM image, let's see if it works out-of-the-box on this brandnew Jetson Nano board.

```bash
pirate@jetson-nano:~$ sudo docker pull hypriot/rpi-busybox-httpd
Using default tag: latest
latest: Pulling from hypriot/rpi-busybox-httpd
c74a9c6a645f: Already exists
6f1938f6d8ae: Already exists
e1347d4747a6: Already exists
a3ed95caeb02: Already exists
Digest: sha256:c00342f952d97628bf5dda457d3b409c37df687c859df82b9424f61264f54cd1
Status: Image is up to date for hypriot/rpi-busybox-httpd:latest
```

The Docker Image is pulled directly from Docker Hub and we can have a closer look, it's pretty small in size with 2.16MByte only and it is already 3 years old.
```bash
pirate@jetson-nano:~$ sudo docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
hypriot/rpi-busybox-httpd   latest              fbd9685c5ffc        3 years ago         2.16MB
```

Now, let's see how it runs on the Jetson Nano.
```bash
pirate@jetson-nano:~$ sudo docker run -d -p 8000:80 hypriot/rpi-busybox-httpd
ed6e7838c9af3f73e6f7129e7c38bf369bb9a33aa67a3b160b1f1c6c7251b2b2

pirate@jetson-nano:~$ sudo docker ps
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS              PORTS                  NAMES
ed6e7838c9af        hypriot/rpi-busybox-httpd   "/bin/busybox httpd …"   8 seconds ago       Up 7 seconds        0.0.0.0:8000->80/tcp   laughing_lalande
```

Opening up a web browser with the URL `http://192.168.7.158:8000` and we should see the web page served by our Docker container running on the NVIDIA Jetson Nano.


![docker-container-webpage.jpg](/images/nvidia-jetson-nano-intro/docker-container-webpage.jpg)

Here is another screenshot directly from the Jetson Nano desktop and a Chromium browser window which is showing our webpage served from the Docker container.

![jetson-desktop-container-webpage.jpg](/images/nvidia-jetson-nano-intro/jetson-desktop-container-webpage.jpg)

**SUCCESS:** Docker Engine 18.06.1-CE is preinstalled on the brandnew NVIDIA Jetson Nano board and even old 32bit ARM Docker Images are running easily!


### Recap

As you can see, there is already a fully running version of the Docker Engine preinstalled on the official SD card image for the NVIDIA Jetson Nano board. The Linux kernel 4.9.x has all the basic features enabled to run containers locally.

So, Docker just works out-of-the-box and you are able to use Docker Images right away. Even 32bit Docker images are able to run on this board because it's based upon an ARM Cortex A57 CPU and this one is capable to run 64bit and 32bit ARM instructions.


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
