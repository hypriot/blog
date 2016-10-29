+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2015-09-10T21:30:00+02:00"
more_link = "yes"
title = "RC1: Jessie with brand new Linux Kernel and Docker"

+++

Here comes __Release Candiate 1__ of our brand new *Get-Docker-Running-in-under-5-Minutes Hypriot SD card image*.
It is the ultimate Docker playground for the Raspberry Pi 1 & 2.

This image builds on the [Beta Version we published six weeks ago](/post/moving-docker-from-wheezy-to-jessie/) and fixes a couple of issues that were reported by our community.
The positiv feedback we got spurred us on to make this release even better.
<!--more-->

And by the way - keep this kind of positiv feedback coming - it really makes a difference and pushes us to be the best we can... :)

So we updated Docker from __1.7.1__ to __1.8.1__.
We also had the impression that our current version of the Linux Kernel - __3.18.11__ - did need some kind of a refresher - so we added the __4.1.6__ version it.

So here again the list of features that make this release really awesome.

### Battle-Tested Docker-Jessie with some sugar
On top of [Jessie](http://arstechnica.com/information-technology/2015/05/debian-8-linuxs-most-reliable-distro-makes-its-biggest-change-since-1993/) we added all the battle-tested ingredients of our previous *Get-Docker-Running-in-under-5-Minutes Hypriot SD card image*:

- a kernel optimised for Docker-awesomeness: __Kernel 4.1.6 with support for OverlayFS__
- the most recent __Docker 1.8.1__
- support for __Pi 1 & 2__ with the same image
- support for __network hotplugging__
- out of the box support for __Wifi__
- support for __Avahi__ (aka Apple Bonjour)
- support for __Open vSwitch__

During the next two weeks we want to improve the SD card image and gather more feedback to make it a great out-of-the-box experience for our users.

### Get it while it is still hot
hypriot-rpi-20150909-070022.img.zip (~ 398 MB)

Check out our [Getting-Started-Guide](/getting-started-with-docker-on-your-arm-device/) on how to get this SD card image running on our Pi.

As always use the comments below to give us feedback and share this post on Twitter or Facebook.

Govinda & Stefan
