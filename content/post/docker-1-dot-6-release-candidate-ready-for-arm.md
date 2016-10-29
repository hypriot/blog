+++
Categories = ["docker"]
Tags = ["hypriotos", "docker", "arm", "raspberry_pi", "release"]
date = "2015-03-31T20:00:00+02:00"
more_link = "yes"
title = "Stay on the cutting edge with Docker 1.6 and test drive it on your Raspberry Pi today"

+++
If you like to stay on the cutting edge of things as much as we do you will be happy to hear that there is an easy way to test drive Docker 1.6 RC2 on your Raspberry Pi.
<!--more-->

### What do you get with Docker 1.6?
Docker 1.6 will bring a couple of new features, changes and bugfixes.

The ones that stand out the most are

- syslog support for the Docker logs
- setting of ulimits for container
- building images from an image id
- pulling images based on id
- Windows client support ([Kitematic](https://kitematic.com) - _I finally see it coming together!_)
- Labels for container and images
- ability to set constraints on images - memory, etc.

Find out more details in the [changelog](https://github.com/docker/docker/blob/v1.6.0-rc2/CHANGELOG.md) yourself.

The only prerequisite to get started is that you are using our Hypriot SD card image for the Rasperry Pi. We published a new version just yesterday and you can the blog post about it here: [HypriotOS: Back Again and Better then Ever](/post/hypriotos-back-again-with-docker-on-arm).

### Get it while it is still hot
[docker-hypriot_1.6.0-rc2-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc2-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc2-1_armhf.deb.sha256)

All you have to do is to start up your Pi with our SD card image, download the prepared Docker package and install it with dpkg.

{{< highlight text >}}

HypriotOS: root@black-pearl in ~
$ wget http://downloads.hypriot.com/docker-hypriot_1.6.0-rc2-1_armhf.deb

HypriotOS: root@black-pearl in ~
$ dpkg -i docker-hypriot_1.6.0-rc2-1_armhf.deb

{{< /highlight >}}

Afterwards you should be able to quench your curiosity by playing with this shiny new toy.
This is not yet a stable release so let us know what you think! And by the way - you can find older versions of Docker as Debian packages in our [Download-Area](/downloads/).
Installing a new version replaces the existing one and thus makes it possible to switch versions without breaking a sweat.

Have fun.

### Update 01.04.2015: Get Docker 1.6.0 RC3
Two hours ago the Docker team released another release candidate, so we've cooked it for you.

[docker-hypriot_1.6.0-rc3-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc3-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc3-1_armhf.deb.sha256)

### Update 03.04.2015: Get Docker 1.6.0 RC4
Well, this time it is already 11 hours since it was published. But still here is the lastest and greatest.

[docker-hypriot_1.6.0-rc4-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc4-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc4-1_armhf.deb.sha256)

### Update 12.04.2015: Get Docker 1.6.0 RC5
[docker-hypriot_1.6.0-rc5-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc5-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc5-1_armhf.deb.sha256)

### Update 14.04.2015: Get Docker 1.6.0 RC6
Maybe this could be the last release candidate before a final 1.6.0 release.

[docker-hypriot_1.6.0-rc6-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc6-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc6-1_armhf.deb.sha256)

### Update 15.04.2015: Get Docker 1.6.0 RC7
OK, here is the next 1.6.0 release candidate.

[docker-hypriot_1.6.0-rc7-1_armhf.deb](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc7-1_armhf.deb) (~ 6MB)  
[SHA256 checksum](http://downloads.hypriot.com/docker-hypriot_1.6.0-rc7-1_armhf.deb.sha256)
