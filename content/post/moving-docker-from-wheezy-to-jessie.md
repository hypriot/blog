+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2015-07-27T20:37:38+02:00"
more_link = "yes"
title = "Moving Docker from Wheezy to Jessie"

+++
__What’s even better then Wheezy? Yes, your right - that’s Jessie.__

And that’s not only because we very much like what crazy stuff _[Jessie](https://blog.jessfraz.com/)_ is doing with Docker.
No, it’s because _Jessie_ is [the next version of the Debian operating system](http://arstechnica.com/information-technology/2015/05/debian-8-linuxs-most-reliable-distro-makes-its-biggest-change-since-1993/) that forms the foundation of our SD card image.
<!--more-->

Jessie updates all the included software to much more recent versions. And most notably it switches the old sys-v-init startup system to systemd.


### Battle-Tested Docker-Jessie with some sugar
On top of that we added all the battle-tested ingredients of our previous Get-Docker-Running-in-under-5-Minutes SD card image:

- a kernel optimised for Docker-awesomeness: __Kernel 3.18.11 with support for OverlayFS__
- the most recent __Docker 1.7.1__
- support for __Pi 1 & 2__ with the same image
- support for __network hotplugging__
- out of the box support for __Wifi__
- support for __Avahi__ (aka Apple Bonjour)
- support for __Open vSwitch__

We consider this new version of our SD card image still as __beta quality__. 
During the next two weeks we want to improve it step by step and gather feedback to make it a great out-of-the-box experience for our users.

### Get it while it is still hot
[hypriot-rpi-20150727-151455.img.zip](http://downloads.hypriot.com/hypriot-rpi-20150727-151455.img.zip) (~ 424 MB)  
[SHA256 checksum](http://downloads.hypriot.com/hypriot-rpi-20150727-151455.img.zip.sha256)

Check out our [Getting-Started-Guide](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) on how to get this SD card image running on our Pi.

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Govinda
