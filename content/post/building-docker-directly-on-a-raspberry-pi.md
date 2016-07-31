+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-07-31T15:24:03+02:00"
draft = false
more_link = "yes"
title = "Building Docker 1.12 on a Raspberry Pi"

+++

Over time many of our users have asked us exactly how we build the Docker Engine
and the associated Debian packages. For instance: they'd like to hack on some
 new features and need the latest software releases as soon as possible.

Here I'll share all the details on building the latest Docker version - even on
a Raspberry Pi itself. Beware: while it's not too complicated it will require
a large amount of time!

![Docker on Raspberry](/images/build-docker-on-raspberrypi/docker-on-raspberrypi.jpg)

So, let's get started. Follow me down the *Rabbit Hole*...

<!--more-->

### Background

The goal of this tutorial is to give you all the details you need to build the
Docker Engine yourself on your cool and fast $35 super-computer (the Raspberry Pi).

### Prepare the Build Environment

Before we begin this arduous task have to prepare our build environment for what
will be a large, long-running workload.

#### Hardware and Software Requirements

For building the Docker Engine in the recommended way we need a Linux computer which
already has a recent version of Docker running. Yeah, the Docker Engine will be build
inside of a Docker container to get a consistent and reproducible build environment.
As this requires some CPU power and disk space, I'm giving you here the minimal
specs for the hardware.

* Raspberry Pi 3 (a Pi 2 will work, but the build process will take even longer!)
* 16 GByte SD card (8 GByte is not enough!)
* enabled swap space (1 GByte of memory is not sufficient!)
* Docker Engine 1.11


#### Installing the Build Environment

As you will see, setting up the build environment is damn easy, because we'll just
use the latest release of HypriotOS which has the required Docker Engine 1.11.1
already pre-installed. These steps here are done on OS X, on a Linux or Windows
box it's a little bit different.

*Step 1:* install HypriotOS 0.8.2 on a SD card

```
$ flash https://github.com/hypriot/image-builder-rpi/releases/download/v0.8.2/hypriotos-rpi-v0.8.2.img.zip
```
Now boot the Raspberry Pi 3 with the newly flashed SD card.

*Step 2:* deploy SSH keys

(Note: login credentials are username=pirate, password=hypriot)

First, wait until the Raspberry Pi is booted up and is visible on the network
to gather it's IP address.
```
$ ping -c 1 black-pearl.local
PING black-pearl.local (192.168.2.113): 56 data bytes
64 bytes from 192.168.2.113: icmp_seq=0 ttl=64 time=5.697 ms
```
Second, deploy your standard SSH keys to the Raspberry Pi.
```
$ ssh-add
$ ssh-keygen -R 192.168.2.113
$ ssh-copy-id pirate@192.168.2.113
```

Now we're able to login into the Raspberry Pi without using a password.
```
$ ssh pirate@192.168.2.113

$ uname -a
Linux black-pearl 4.4.15-hypriotos-v7+ #1 SMP PREEMPT Mon Jul 25 08:46:52 UTC 2016 armv7l GNU/Linux
```

*Step 3:* install some build dependencies

```
$ sudo apt-get update
$ sudo apt-get install -y make
```

*Step 4:* using a swap file

This will create and use a default 2x 1GByte swap file at /var/swap.

```
$ sudo apt-get install -y dphys-swapfile
$ ls -alh /var/swap
-rw------- 1 root root 1.8G Jul 30 17:58 /var/swap
```

If we need a larger swap file, we could edit the config file `/etc/dphys-swapfile`,
but for our use case the default 1.8 GByte swap file is sufficient.


### Clone the Docker repo

```
$ git clone https://github.com/docker/docker.git
$ cd docker
$ git checkout v1.12.0
```
As you can see, we're using a tagged release for Docker to build this exact version.

### How to apply some extra Pull Requests

Just to be honest, right now the build process for Docker v1.12.0 will fail on ARM.
This is a known issue and will be fixed hopefully soon. But luckily there is already
a [pull request](https://github.com/docker/docker/pull/25192)
which enables us to build the Docker .deb packages. This gives me
the change to explain how you can easily apply a PR on top of a release version.

So, let's cherry pick this specific pull request.
```
$ git fetch origin pull/25192/head:fix-manpages-on-arm
$ git cherry-pick fix-manpages-on-arm
```

And finally let's check if everything is OK with the git history.
```
commit e15322b4fcb173674fd62a329a51b0756f02d503
Author: Daniel Nephin <dnephin@docker.com>
Date:   Thu Jul 28 14:53:08 2016 -0400

    Fix the man/Dockerfile for arm

    Signed-off-by: Daniel Nephin <dnephin@docker.com>

commit 8eab29edd820017901796eb60d4bea28d760f16f
Author: Tibor Vass <tibor@docker.com>
Date:   Wed Jul 27 16:35:10 2016 -0700

    Bump VERSION to v1.12.0

    Signed-off-by: Tibor Vass <tibor@docker.com>
```
As you can see, the second last commit is the release commit for the official v1.12.0
version of the Docker Engine. The last commit is from the applied PR.


### Run the Builder

And here comes the really boring magic, we'll start the building process and have
to wait for a really long time to get the build finished.
```
$ time make deb

...
real	350m48.228s
user	0m22.140s
sys	0m4.870s
```

The complete build process takes almost 6 hours on a fast Raspberry Pi 3, but finally
we'll get the Docker Engine v1.12.0 build for a few different ARM operating systems.
```
$ ls -al ~/docker/bundles/1.12.0/build-deb/*/*.deb
-rw-r--r-- 1 root root 15933554 Jul 31 10:46 /home/pirate/docker/bundles/1.12.0/build-deb/debian-jessie/docker-engine_1.12.0-0~jessie_armhf.deb
-rw-r--r-- 1 root root 15945462 Jul 31 12:28 /home/pirate/docker/bundles/1.12.0/build-deb/raspbian-jessie/docker-engine_1.12.0-0~jessie_armhf.deb
-rw-r--r-- 1 root root 15915910 Jul 31 13:40 /home/pirate/docker/bundles/1.12.0/build-deb/ubuntu-trusty/docker-engine_1.12.0-0~trusty_armhf.deb
```

To install the Docker Engine on our Raspberry Pi's, we just pick
`raspbian-jessie/docker-engine_1.12.0-0~jessie_armhf.deb`.

Here is the install process on HypriotOS:
```
$ sudo apt-get purge -y docker-hypriot
$ sudo dpkg -i docker-engine_1.12.0-0~jessie_armhf.deb
```

And now we do have the latest release version v1.12.0 of the Docker Engine running
on our Raspberry Pi.
```
$ docker version
Client:
 Version:      1.12.0
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   e15322b4f
 Built:        Sun Jul 31 11:41:45 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.12.0
 API version:  1.24
 Go version:   go1.6.3
 Git commit:   e15322b4f
 Built:        Sun Jul 31 11:41:45 2016
 OS/Arch:      linux/arm
```

### What other build options can be used?

We do have some Raspberry Pi users who wants to run Docker on ArchLinux or other
non-supported OSes. And for them it's also easy to build the Docker binaries in
a static version as well.

```
$ cd ~/docker
$ time make binary
```


### Lessons learned

With the right Raspberry Pi OS and the Docker Engine already pre-installed, it's
pretty easy and straight forward to build the next version of the Docker Engine
directly and natively on a standard Raspberry Pi.

I strongly recommend to use the faster Raspberry Pi 3 and a SD card of at least
16 GByte, with a smaller SD card the build will crash after some hours and you
have to start all over again!


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
