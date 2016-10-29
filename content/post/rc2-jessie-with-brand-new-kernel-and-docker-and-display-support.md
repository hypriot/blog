+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2015-09-28T21:00:00+02:00"
more_link = "yes"
title = "RC2: Jessie with upgraded Firmware, Linux Kernel and Docker-Engine"

+++

Here comes __Release Candiate 2__ of our brand new *Get-Docker-Running-in-under-5-Minutes Hypriot SD card image*.
It is the ultimate Docker playground for the Raspberry Pi 1 & 2.

This image builds on the [RC1 we released roughly two weeks ago](http://blog.hypriot.com/post/rc1-jessie-with-brand-new-kernel-and-docker/) and fixes a couple of issues that were reported by our community.

We also upgraded the included firmware as well as the Linux-Kernel- and the Docker-Version.
<!--more-->

We finally managed to add out-of-the-box support for [Docker-Compose](https://docs.docker.com/compose/) and [Docker-Swarm](https://docs.docker.com/swarm/) in our image.
Docker-Compose helps you manage a group of containers that make up your application. And if working on one server/device is not enough for you you might wanna look into Docker-Swarm as it allows you to manage a cluster of Docker-Engines on multiple servers/devices.

Another noteably thing that we now support is the [official 7" display of the Raspberry PI foundation](https://www.raspberrypi.org/blog/the-eagerly-awaited-raspberry-pi-display/).
Just attach it to your PI and you should be able to use Docker together with the awesomeness of a beautiful GUI at once.
That's exactly what one of our users did last week by using [a beautiful Node.js-App on HypriotOS](https://medium.com/@icebob/jessie-on-raspberry-pi-2-with-docker-and-chromium-c43b8d80e7e1).

Albeit he still had to add support for the 7" display manually on his own.  
As of today this is not necessary anymore as we upgraded the included Raspberry PI Firmware to a more recent version that supports a number of new displays.

And last but not least we updated Docker from version __1.8.1__ to __1.8.2__ and the included Linux Kernel from __4.1.6__ to __4.1.8__..

So here comes an overview of all the things that are part of our new Hypriot SD card image...

### Battle-Tested Docker-Jessie with some sugar
On top of [Jessie](http://arstechnica.com/information-technology/2015/05/debian-8-linuxs-most-reliable-distro-makes-its-biggest-change-since-1993/) we added all the battle-tested ingredients of our previous *Get-Docker-Running-in-under-5-Minutes Hypriot SD card image*:

- a kernel optimised for Docker-awesomeness: __Kernel 4.1.8 with support for OverlayFS__
- the most recent __Docker 1.8.2__
- support for __Pi 1 & 2__ with the same image
- Docker-Compose __1.4.2__ included
- Docker-Swarm __0.4.0__ included
- support for __network hotplugging__
- support for a couple of Raspberry PI displays
- out of the box support for __Wifi__
- support for __Avahi__ (aka Apple Bonjour)
- support for __Open vSwitch__

During the next two weeks we want to improve the SD card image and gather more feedback to make it a great out-of-the-box experience for our users.

### Get it while it is still hot
hypriot-rpi-20150928-174643.img.zip (~ 438 MB)

Check out our [Getting-Started-Guide](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) on how to get this SD card image running on our Pi.

As always use the comments below to give us feedback and share this post on Twitter or Facebook.

Govinda, Stefan & Dieter
