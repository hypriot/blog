+++
date = "2019-04-22T08:44:52+02:00"
title = "NVIDIA Jetson Nano - Upgrade Docker Engine"
draft = false
more_link = "yes"
Tags = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]
Categories = ["Docker","Nvidia","Jetson","Nano","ARM","64bit","ARM64","AARCH64","Container"]


+++

In our last blogposts about the [NVIDIA Jetson Nano Developer Kit - Introduction](https://blog.hypriot.com/post/nvidia-jetson-nano-intro/) and [NVIDIA Jetson Nano - Install Docker Compose](https://blog.hypriot.com/post/nvidia-jetson-nano-install-docker-compose/) we digged into the brand-new **NVIDIA Jetson Nano Developer Kit** and we know, that Docker 18.06.1-CE is already installed, but...

![jetson-desktop-login.jpg](/images/nvidia-jetson-nano-docker-ce/jetson-desktop-login.jpg)

But, this isn't the latest available version of the Docker Engine. So, I'd like to point you to a few different options on how to upgrade the Docker Engine to the very latest available version for the NVIDIA Jetson Nano.

<!--more-->

### Check the current Docker Version

For this tutorial I'm starting again with a freshly flashed SD card image.

Flashing from macOS just takes a few minutes with the Hypriot flash utility, which can be found here https://github.com/hypriot/flash.
```bash
$ time flash --device /dev/disk2 jetson-nano-sd-r32.1-2019-03-18.img

Is /dev/disk2 correct? y
Unmounting /dev/disk2 ...
Unmount of all volumes on disk2 was successful
Unmount of all volumes on disk2 was successful
Flashing jetson-nano-sd-r32.1-2019-03-18.img to /dev/rdisk2 ...
12.0GiB 0:03:40 [55.8MiB/s] [=======================================================================================>] 100%
0+196608 records in
0+196608 records out
12884901888 bytes transferred in 220.275160 secs (58494575 bytes/sec)
Mounting Disk

real	3m47.866s
user	0m1.648s
sys	0m30.921s
```

Next we have to attach a computer monitor via HDMI cable, mouse and keyboard and of course an Ethernet cable in order to get an internet connect. Now connecting to a micro-USB power supply and follow the instruction on the screen to perform the initial setup of the NVIDIA Jetson Nano Developer Kit. This will take around 5 to 10 minutes and we do have a new Ubuntu 18.04 desktop running on that nice 64bit ARM Cortex-A57 developer board.


**Pro-Tip on using Docker client:**

As we have seen in the last blogpost, we have to use sudo when we're calling a docker command in the shell. This can be easily resolved, we only have to issue the following command ones.
```bash
pirate@jetson-nano:~$ sudo usermod -aG docker pirate
```

Next, log out and log in again or just start a new shell and we don't have to use sudo any more for our docker commands.

Show the current version of the Docker Engine installed on the Nano.
```bash
pirate@jetson-nano:~$ docker version
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

And here we see the version `18.06.1-ce` of the Docker Engine, which is installed on the Nano SD card image `jetson-nano-sd-r32.1-2019-03-18.img`. And yes, this is by far not the latest nor the securest available version at all.


### Upgrade Docker Engine

As we've seen in the previous section, the installed Docker Engine version is 18.06.01-ce. Now let's verify if there is already a newer version available.

We can just use the apt utility from the Ubuntu package manager to determine the installed versions of any of the installed software packages. Here on Ubuntu 18.04 the Docker Engine is installed through the `docker.io` package.
```bash
pirate@jetson-nano:~$ apt list --installed | grep docker.io

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

docker.io/bionic-security,now 18.06.1-0ubuntu1.2~18.04.1 arm64 [installed,upgradable to: 18.09.2-0ubuntu1~18.04.1]
```

We can see the newer Docker version 18.09.2 is already available in the Ubuntu repository, so we're going to upgrade the software package `docker.io`.
```bash
pirate@jetson-nano:~$ sudo apt-get --only-upgrade install docker.io
```

At the end we were able to upgrade the Docker Engine to the very latest version which is provided by the Ubuntu repository.
```bash
pirate@jetson-nano:~$ docker version
Client:
 Version:           18.09.2
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        6247962
 Built:             Tue Feb 26 23:51:35 2019
 OS/Arch:           linux/arm64
 Experimental:      false

Server:
 Engine:
  Version:          18.09.2
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       6247962
  Built:            Wed Feb 13 00:24:14 2019
  OS/Arch:          linux/arm64
```

Finally we have upgraded the Docker Engine to version 18.09.2. Please keep in mind, this version of the Docker Engine is provided by the Ubuntu repository. Maybe there is even a newer version available directly from the Docker open source project.


### Recommendation: Install official Docker Engine CE

For this step I can truely recommend to use the official Docker documentation for the Community Edition. For installing Docker Engine CE on Ubuntu you can directly follow the detailled steps at https://docs.docker.com/install/linux/docker-ce/ubuntu/.

As you can see later, Docker Engine CE is also available for ARM 64bit on Ubuntu 18.04 LTS. It's not too complicated to set it up, just follow the installation steps in this documentation and within a few minutes you have installed the official Docker Engine! 

**Step 1:** Uninstall old versions
```bash
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

**Step 2:** Set up the repository
```bash
# 1. Update the apt package index:
$ sudo apt-get update

# 2. Install packages to allow apt to use a repository over HTTPS:
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# 3. Add Docker’s official GPG key:
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]

# 4. Use the following command to set up the stable repository:
#    here select the commands for "arm64"
$ sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
```bash
# Alternatively you can also select the "edge" channel for the very latest version
$ sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"
```

**Step 3:** Install Docker CE
```bash
# 1. Update the apt package index.
$ sudo apt-get update

# 2. Install the latest version of Docker CE and containerd
$ sudo apt-get install docker-ce docker-ce-cli containerd.io

# 3. Add user "pirate" to the group "docker", so we don't need sudo
$ sudo usermod -aG docker pirate
# Now logout and login again
```

**Step 4:** Show the installed Docker Engine version
```bash
pirate@jetson-nano:~$ docker version
Client:
 Version:           18.09.5
 API version:       1.39
 Go version:        go1.10.8
 Git commit:        e8ff056
 Built:             Thu Apr 11 04:48:27 2019
 OS/Arch:           linux/arm64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.5
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.8
  Git commit:       e8ff056
  Built:            Thu Apr 11 04:11:17 2019
  OS/Arch:          linux/arm64
  Experimental:     false
```

**Step 5:** Run the `docker info` command
```bash
pirate@jetson-nano:~$ docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 18.09.5
Storage Driver: overlay2
 Backing Filesystem: extfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: bb71b10fd8f58240ca47fbb579b9d1028eea7c84
runc version: 2b18fe1d885ee5083ef9f0838fee39b62d653e30
init version: fec3683
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
ID: 4JER:EIWM:QFNF:6N2C:YUW3:YES2:RSP5:Z4D2:7PKI:YAOT:G5O7:5N25
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Live Restore Enabled: false
Product License: Community Engine
```

**Step 6:**  Start first Docker container
```bash
pirate@jetson-nano:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
3b4173355427: Pull complete
Digest: sha256:92695bc579f31df7a63da6922075d0666e565ceccad16b59c3374d2cf4e8e50e
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

![jetson-desktop-docker-ce.jpg](/images/nvidia-jetson-nano-docker-ce/jetson-desktop-docker-ce.jpg)


### Conclusion

As you could see, on the Jetson Nano DevKit there is already a version of the Docker Engine installed and it's maintained by the Ubuntu project. But this is not the latest version available and it will not get updated fast enough to include all important security fixes in time.

Therefore I'd like to strongly recommend to use the Docker Engine CE from the official Docker project. It's well maintained and updated in time. All installation steps and options are also extremely well documented at https://docs.docker.com/install/linux/docker-ce/ubuntu/.

And in case you need more help or having some technical questions about running Docker on an ARM 64bit system like the NVIDIA Jetson Nano, there is an `arm` Slack channel available for you at the [DockerCommunity Slack](https://dockercommunity.slack.com/messages/C2293P89Y).


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
