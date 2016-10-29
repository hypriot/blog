+++
Categories = ["docker", "raspberry_pi"]
Tags = ["docker", "raspberry_pi", "release", "hypriotos"]
date = "2015-03-03T22:09:33+01:00"
title = "Heavily ARMed after major upgrade: Raspberry Pi with Docker 1.5.0"
aliases = [ "heavily-armed-after-major-upgrade-raspberry-pi-with-docker-1-dot-5-0" ]

disqus_url = "http://blog.hypriot.com/post/heavily-armed-after-major-upgrade-raspberry-pi-with-docker-1-dot-5-0"
disqus_title = "Heavily ARMed after major upgrade: Raspberry Pi with Docker 1.5.0"

tweet_url = "http://blog.hypriot.com/heavily-armed-after-major-upgrade-raspberry-pi-with-docker-1-dot-5-0"
facebook_url = "http://blog.hypriot.com/heavily-armed-after-major-upgrade-raspberry-pi-with-docker-1-dot-5-0"

more_link = "yes"

galleryprefix = "/images/gallery"
galleryfolder = "heavily-armed-after-major-upgrade"
gallerythumbnail = "thumbnails"
+++

Nearly two weeks ago we have been blown away by the positive feedback we got for [our first Raspberry Pi SD card image](http://blog.hypriot.com/kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1). It allowed people to get up and running with Docker on the Raspberry Pi in no time.

The positive feedback we received and the fact that two days later Docker 1.5.0 was released did motivate us to create an improved version of our Get-Docker-Up-And-Running-On-Your-Pi-In-No-Time SD card image.
<!--more-->

{{< image file="/images/gallery/heavily-armed-after-major-upgrade/black-pearl.jpg" copyright="Kevin Boone" copyright_link="http://www.kevinboone.net/black_pearl.html" >}}

The most important upgrade of our second image is the support for Docker 1.5.0 which has been released just recently. Most noteworthy about Docker 1.5.0 is the new support for IPv6, read-only containers and advanced statistics for image resource consumption. We find the last one especially interesting for people like us who are running Docker on small devices.

One thing we already had in the last incarnation of our image is the support of OverlayFS. OverlayFS is one of several storage drivers for Docker. The biggest distinction to other storage options, like lvm or btrfs, is the performance it offers. See this [website](https://developerblog.redhat.com/2014/09/30/overview-storage-scalability-docker/) for an in-depth-look at the performance/advantages of different docker storage options.
Needless to say that OverlayFS comes out at the top. Even the big players like [CoreOS](http://lwn.net/Articles/627232/) seem to be in the process of moving to OverlayFS. We can provide OverlayFS in our image because with 3.18.8 we are using the latest linux kernel version which already has built-in support for OverlayFS.

{{< gallery title="Raspberry Pi with Docker" >}}
{{% galleryimage file="hypriot-pi-01.jpg" size="1600x1008" caption="Modern Kernel build for Docker" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot-pi-02.jpg" size="1600x1008" caption="Output of 'docker version'" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot-pi-03.jpg" size="1600x1008" caption="Output of 'docker info'" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot-pi-04.jpg" size="1600x1008" caption="Output of 'docker images'" copyrightHolder="Hypriot" %}}
{{< /gallery >}}

{{% galleryinit %}}

## Summary of changes
Here is a list of the most important changes to the SD card image.  

We ...

- upgraded the linux kernel from 3.18.6 to _3.18.8_
- added kernel headers to support compilation of custom modules
- upgraded from Docker 1.4.1 to _1.5.0_
- added support for using a [USB to TTL serial console cable](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/overview)
- added bash completion for Docker commands
- lots of smaller fixes and improvements

Besides that we kept some features which were already awesome

- the image is based on Raspbian Wheezy
- support for OverlayFS by default
- support for Raspberry Pi 1 & 2 with the same SD card image (dual kernel)

## Download
The image can be downloaded here:

[Docker-Pi Image](http://downloads.hypriot.com/hypriot-rpi-20150301-140537.img.zip) (~347MB)  
[SHA256 checksum](http://downloads.hypriot.com/hypriot-rpi-20150301-140537.img.zip.sha256)

__Update (30.03.2015):__ We have published a more [recent version of our SD card image](http://blog.hypriot.com/post/hypriotos-back-again-with-docker-on-arm).

## How to get started
Download our SD card image and flash it on your own SD card. [Here](http://computers.tutsplus.com/articles/how-to-flash-an-sd-card-for-raspberry-pi--mac-53600) is a short guide on how to do this for Mac, Windows and Linux users. Afterwards insert the SD card in your Raspberry Pi and wait while it boots. The first time will take a little longer as it resizes the file system to its maximum and reboots again.

At the boot prompt log in with user "pi" and password "raspberry" (or with a privileged user "root" and password "hypriot").

One thing that is still worth mentioning is that you need special ARM-compatible Docker Images.
Standard x86-64 Docker Images from the Docker Hub won't work. That's the reason why we've created a number of ARM compatible Docker Images to get you started. Wether you prefer Java, Python, Node.js or io.js - we have you covered!

You will find these images and more at our place on the Docker Hub. After booting our image on your Pi these base images are just a "docker pull" away. For example "docker pull hypriot/rpi-node".

As you can see - getting started with Docker on your Raspberry Pi just got so much easier!

## Give us your feedback
As we want to make this image even better we really need your feedback. What do you like about our SD card image and what could be made better? And what kind of additional Docker Images would you like to see?

Tell us via Twitter, HackerNews or in the comments!
And please share this post with your friends.

We really would like to see more people using Docker on Raspberries as we think they make a really hot combo:
Low-cost instant access to Docker awesomeness on your Raspberry Pi.
