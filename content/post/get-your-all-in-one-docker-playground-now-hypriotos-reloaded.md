+++

Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2015-10-07T17:30:00+02:00"
more_link = "yes"
title = "Get your all-in-one Docker playground now: HypriotOS reloaded!"
+++

We are happy to announce that after months of hard work we are now releasing a new major version of HypriotOS called ["Will"](https://en.wikipedia.org/wiki/Will_Turner).

Highlights are the upgrade from Raspberry Wheezy to Jessie, the upgrade of the included Raspberry Pi firmware, support for Device Tree and the addition of the most recent versions of Docker Compose, Docker Swarm and Docker Machine to the image.

It is - more than ever - __the ultimate Docker playground for the Raspberry Pi 1 & 2__.

![](/images/jessie-release/one-to-rule-them-all_blog.jpg)

<!--more-->

We have been coming a long way since we started in February 2015. Then Docker was not easily available for ARM-based devices.
By following long - often outdated - tutorials, only technically well-versed people had a chance to eventually get Docker running on ARM.
It also didn't help that Docker wasn't offically supported on ARM and 32-bit systems.

As avid Docker users and owners of various ARM devices our mission from the beginning was to make Docker a first-class citizen in the ARM world.
The most popular ARM device that is easily available at reasonable costs is the [Raspberry Pi](https://www.raspberrypi.org/help/what-is-a-raspberry-pi/). More than 5 millions devices have been sold until now.
Thus it was an obvious choice for us to start our mission on the Raspberry Pi.

The standard way to provide software for the Raspberry Pi is by using a SD card that includes the operating system with all necessary user software.
So our first step was to provide a SD card image that included an operating system that was optimized for the use of Docker.
And that was exactly what we did when we published the [first version](http://blog.hypriot.com/post/kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1/) of our Get-Docker-Up-And-Running-On-Your-Pi-In-No-Time SD card image.
It allowed even novice users to get a working Docker environment running in minutes.

Besides the ease of use there was another important "feature" for us when we started publishing our SD card image.
We wanted to provide our users with new Docker versions as soon as they were available.
And that's exactly what we did: Sometimes within minutes after a new Docker version was released you would find it on our website ready to be downloaded.

Following this approach we did not only update the Docker Engine on a regular basis, but also the included Linux kernel and various other components that made the work with our image easier or more interesting.
The positive feedback we got, spurred us on to tackle a new challenge at the end of July: upgrading the foundation of our SD card image from Raspbian Wheezy to Jessie.
Since August we had three preview releases and we now have not only upgraded HypriotOS from Raspbian Wheezy to [Jessie](http://arstechnica.com/information-technology/2015/05/debian-8-linuxs-most-reliable-distro-makes-its-biggest-change-since-1993/), but we also have upgraded the Linux kernel from 3.18.11 to 4.1.8.
And that's not all: the most exciting addition is that we now support most of the Docker tools besides the Docker Engine.
This includes the most recent versions of [Docker Compose](https://docs.docker.com/compose/), [Docker Swarm](https://docs.docker.com/swarm/) and [Docker Machine](https://docs.docker.com/machine/).

__We believe this makes our SD card image one of the easiest and straightforward ways to get started with Docker and its ecosystem!__

We also improved the way how upgrades can be done. In the past, upgrading basically meant to reflash your SD card with the newest version of HypriotOS.
To allow upgrading of individual components, without reflashing the SD card, we now have set up our own package repository.
`apt` in our new image is configured to use it by default - thus an upgrade is just an `apt-get update && apt-get install docker-compose` away.

We also massively improved the out-of-the-box support for different hardware extensions that are available for the Raspberry Pi.

To achieve that we upgraded to the lastest Raspberry Pi firmware and added support for [Device Tree](http://www.devicetree.org/).
With the help of Device Tree many hardware devices like displays and Pi Hats should just work(tm) now.
One great example is [The official 7" touch display of the Raspberry Pi foundation](https://www.raspberrypi.org/blog/the-eagerly-awaited-raspberry-pi-display/).
Just attach it to your Pi and you can use it right away.
Besides adding Device Tree we also added support for more WiFi-Dongles from Ralink, Realtec and Atheros.
We hope that all these measures contribute to a much smoother out-of-the-box hardware experience for our users.

All in all we think that this release is a major step forward and we hope, you enjoy it as much as we do!
Rest assured that we still have some more major improvements in our release pipeline which we will announce soon.


### Detailed Features of HypriotOS "Will"
- a modern operating system based on __Raspbian Jessie__
- a recent Raspberry Pi firmware and Device Tree to __support a huge range of hardware add-ons__
- a kernel optimized for Docker-awesomeness: __Kernel 4.1.8 with support for OverlayFS__
- support for __Pi 1 & 2__ with the same SD card image
- __Docker Engine 1.8.2__
- __Docker Compose 1.4.2__
- __Docker Machine 0.4.1__
- __Docker Swarm 0.4.0__
- support for __network hotplugging__
- out-of-the-box support for __WiFi__
- support for __Avahi__ (aka mDNS aka Apple Bonjour)
- support for __Open vSwitch__
- our own package repository to easily update individual components


### Download: Get it while it is still hot
[hypriot-rpi-20151004-132414.img.zip](http://downloads.hypriot.com/hypriot-rpi-20151004-132414.img.zip) (~ 438 MB)
[SHA256 checksum](http://downloads.hypriot.com/hypriot-rpi-20151004-132414.img.zip.sha256)


Check out our [Getting-Started-Guide](http://blog.hypriot.com/getting-started-with-docker-on-your-arm-device/) on how to get this SD card image running on our Pi.

As always, use the comments below to give us feedback and share this post on Twitter or Facebook.
You also might wanna discuss this release on [HackerNews](https://news.ycombinator.com/item?id=10351792) or vote it up if you find it interesting.

Your Hypriot-Team -
Stefan, Dieter, Mathias, Andreas, Govinda
