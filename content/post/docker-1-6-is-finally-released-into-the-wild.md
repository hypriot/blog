+++
Categories = ["docker", "raspberry_pi", "Docker Compose", "arm"]
Tags = ["docker", "raspberry_pi", "compose", "arm", "release"]
date = "2015-04-16T22:06:11+02:00"
more_link = "yes"
title = "Docker 1.6.0 is finally released into the wild"
draft = false
+++

After nearly two months of development Docker 1.6.0 was finally released into the wild.
Being right on the heels of the Docker team we were able to create an ARM compatible version within minutes and of course you can download it here as a Debian package.

<!--more-->

Our Docker Debian packages are battle-tested only with our HypriotOS Docker SD card image.
Use it to get the best Docker experience available for the Raspberry Pi. It is ridiculous easy to get up and running. Under 5 minutes - promised!

The image can be downloaded here:

Docker-Pi Image (hypriot-rpi-20150416-201537.img.zip) (~369MB)  

For everybody else use our Docker Debian package at your own peril... :)

## All new shiny Docker 1.6.0
Alright back to Docker... version 1.6.0 will bring a couple of new features, changes and bugfixes.

The ones that stand out the most are

- syslog support for the Docker logs
- setting of ulimits for container
- building images from an image id
- pulling images based on id
- Windows client support ([Kitematic](https://kitematic.com) - _I finally see it coming together!_)
- Labels for container and images
- ability to set constraints on images - memory, etc.

Find out more details in the [changelog](https://github.com/docker/docker/blob/v1.6.0/CHANGELOG.md) yourself.

Read some more details on the official Docker blog
[DOCKER 1.6: ENGINE & ORCHESTRATION UPDATES, REGISTRY 2.0, & WINDOWS CLIENT PREVIEW](https://blog.docker.com/2015/04/docker-release-1-6/)

## Get it while it is still hot
docker-hypriot_1.6.0-1_armhf.deb

All you have to do is to start up your Pi with our SD card image, download the prepared Docker package and install it with dpkg.

{{< highlight text >}}

HypriotOS: root@black-pearl in ~
$ wget http://downloads.hypriot.com/docker-hypriot_1.6.0-1_armhf.deb

HypriotOS: root@black-pearl in ~
$ dpkg -i docker-hypriot_1.6.0-1_armhf.deb

{{< /highlight >}}

Afterwards you should be able to quench your curiosity by playing with the latest and greatest Docker Engine.

And if you are especially daring today you might wanna try it together with Docker Compose:

http://blog.hypriot.com/post/docker-compose-nodejs-haproxy

Have fun!

As always use the comments below to give us feedback and like this post on Twitter or Facebook.
