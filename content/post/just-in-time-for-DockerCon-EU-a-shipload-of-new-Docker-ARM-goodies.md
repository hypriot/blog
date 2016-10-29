+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM", "DockerCon EU"]
date = "2015-11-15T21:40:00+01:00"
more_link = "yes"
title = "Just in time for DockerCon EU: a shipload of new Docker ARM goodies"

+++

Hard on the heels of Docker announcing [major changes with Docker 1.9](https://blog.docker.com/2015/11/docker-1-9-production-ready-swarm-multi-host-networking/) we are making the newest Docker goodies available on HypriotOS.
We are really happy that we were able to finish our new release called "Hector" just in time for DockerCon EU.

If you like a personal demo of what's in store for "Hector" just ping @Quintus23M on Twitter and meet him in person at DockerCon EU.
Dieter and Andreas brought their treasure chest filled with Raspberry Pi's to Barcelona and are eager to show off a bit.

![](/images/hector-release/testing.jpg)

<!--more-->
And if you are not lucky enough to attend DockerCon you might as well read on.

To name just a few of the highlights, there is now [multi-host networking](http://blog.docker.com/2015/11/docker-multi-host-networking-ga/), extensively improved volume management and a production-ready [Swarm](http://blog.docker.com/2015/11/swarm-1-0/).

__HypriotOS - the ultimate Docker playground for your Raspberry Pi 1 & 2__ has you covered once again: all the cool & latest Docker tools in one convenient package.

Compared with HypriotOS "Will" we updated

- the __Linux Kernel__ from 4.1.8 to __4.1.12__
- the __Docker Engine__ from 1.8.2 to __1.9.0__
- __Docker Compose__ from 1.4.2 to __1.5.1__
- __Docker Swarm__ from 0.4.0 to __1.0.0__

Besides that we enabled some missing cgroup kernel settings for better Docker support.
We also added a default `/boot/config.txt`, which for instance allows for a better out-of-the-box HDMI display experience (`hdmi_force_hotplug=1`).

There is no easier way to get started with Docker on ARM.
Just give it a try: Download our [latest image](http://downloads.hypriot.com/hypriot-rpi-20151115-132854.img.zip) and get started in less than 5 minutes.


### Detailed Features of HypriotOS "Hector"
- a modern operating system based on __Raspbian Jessie__
- a recent Raspberry Pi firmware and Device Tree to __support a huge range of hardware add-ons__
- a kernel optimized for Docker-awesomeness: __Kernel 4.1.12 with support for OverlayFS__
- support for __Raspberry Pi 1 & 2__ with the same SD card image
- __Docker Engine 1.9.0__
- __Docker Compose 1.5.1__
- __Docker Machine 0.4.1__
- __Docker Swarm 1.0.0__
- support for __network hotplugging__
- out-of-the-box support for __WiFi__
- support for __Avahi__ (aka mDNS aka Apple Bonjour)
- support for __Open vSwitch__
- our own package repository to easily update individual components


### Download: Get it while it is still hot
[hypriot-rpi-20151115-132854.img.zip](http://downloads.hypriot.com/hypriot-rpi-20151115-132854.img.zip) (~ 438 MB)
[SHA256 checksum](hypriot-rpi-20151115-132854.img.zip.sha256)

Check out our [Getting-Started-Guide](/getting-started-with-docker-on-your-arm-device/) on how to get this SD card image running on your Raspberry Pi.

As always, use the comments below to give us feedback and share this post on Twitter, Google+ or Facebook.

Your Hypriot-Team -
Stefan, Dieter, Mathias, Andreas, Govinda
