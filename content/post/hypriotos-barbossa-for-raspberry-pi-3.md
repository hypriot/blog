+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-05-25T03:30:00+00:00"
draft = false
more_link = "yes"
title = "HypriotOS 0.8.0 Barbossa for Raspberry Pi 3"
+++

While it is quite hard to make something better that is already good, we feel that we were able to just do that with our latest release of HypriotOS.

__HypriotOS is the easiest and fastest way to get you started with Docker on ARM and IoT devices.__

It is the perfect playground for your first steps with Docker and it allows you to move to advanced stuff like Docker Clustering without breaking a sweat, too.

This is possible because we included a lot of the tools that make the Docker ecosystem awesome - for instance Docker Compose or Docker Swarm - out of the box.
We also integrated the Hypriot Cluster-Lab into this release, which makes it really easy and painless to set up complex Docker Clusters.

And that's just the tip of the iceberg. So read on to get all the glory details of this new release ... :)

![Raspberry Pi 3](/images/hypriotos-barbossa/iceberg.jpg)
<div style="text-align:right; font-size: smaller">Image courtesy of [David](https://www.flickr.com/photos/davidw/)</div>

<!--more-->

## Features at a glance

* support for Raspberry Pi Zero, 1, 2 and 3
* Linux kernel 4.4.10
* Docker Engine 1.11.1
* Docker Compose 1.7.1
* Docker Machine 0.7.0
* Docker Swarm 1.2.2
* Cluster-Lab 0.2.8
* device-init 0.1.5


## Updated Docker and Docker-Tools
Compared to our latest HypriotOS Berry 0.7 we did upgrade the Docker Engine to v1.11 which now has several binaries instead of one.
Besides the original Docker binary there is now also a Containerd and a runC binary. Containerd is basically a supervisor for individual containers that are run by runC.

The main reasons for splitting up the Docker binary were the efforts of Docker to support the [standardization of container technology](https://www.opencontainers.org/) and to make it easier to maintain the existing technology stack.
You can get a good overview about these changes in the [blog post](https://blog.docker.com/2016/04/docker-engine-1-11-runc/) announcing the release of Docker 1.11.

And there is also a very interesting deep dive into the details of those changes:

<iframe id="ytplayer" type="text/html" width="1000" height="560" src="http://www.youtube.com/embed/QL8F2MLCybo" frameborder="0"></iframe>

## Full Raspberry Pi 3 Support
Noteworthy is also that we now have full support for the Raspberry Pi 3.

With the help of our [flash-tool](https://github.com/hypriot/flash) it is really easy to bring a Raspberry Pi 3 online with only WiFi network connectivity:

```
flash --ssid MyNetworkName --password SomeSecret https://github.com/hypriot/image-builder-rpi/releases/download/v0.8.0/hypriotos-rpi-v0.8.0.img.zip
```

After that you can usually connect to your Pi by:

```
ssh pirate@black-pearl.local
```

The password is 'hypriot'. And that's it.

By the way this also works if you attach an external WiFi adapter to a Raspberry Pi Zero, 1 and 2.

## Customizing your Raspberry Pi Configuration
The ability to customize the hostname of your Pi, to add WiFi credentials and more is made possible by a small tool of ours called [device-init](https://github.com/hypriot/device-init).

In previous versions we used a tool called [occi](https://github.com/adafruit/Adafruit-Occi) from Adafruit to allow hostname and WiFi customization.

In this release we removed it and replaced it with device-init.

device-init is a small programm that is started when your Raspberry Pi boots and it allows to customize a couple of settings.
It takes its configuration from a file called 'device-init.yaml' which is located in the /boot directory.

This /boot directory is basically a small FAT partition on the SD card that contains HypriotOS.
It can be easily accessed from your host computer before you boot your Pi. You can edit the 'device-init.yaml' file directly with a text editor or by using the flash tool as demonstrated above.

We are going to add more features - like adding public ssh keys, setting the locale or timezone - to device-init step by step in the next weeks.

## Hypriot Cluster-Lab
We added the Hypriot Cluster-Lab to the image, too.

It is disabled by default, but can easily be enabled when you flash the image:

```
flash --clusterlab true https://github.com/hypriot/image-builder-rpi/releases/download/v0.8.0/hypriotos-rpi-v0.8.0.img.zip
```

Setting this options starts the Cluster-Lab on boot.

By flashing a couple of SD cards with different hostnames and Cluster-Lab enabled you can get a fully working Docker Swarm cluster up and running in minutes.
The individual machines will find themselves automatically and form a Swarm cluster.

You can read more about the Hypriot Cluster-Lab and why it is awesome on [its website](https://github.com/hypriot/cluster-lab/).

You can download the new release in our [download section](/downloads).

If you encounter any problems with this new release please open up issues in one of the following repositories:

https://github.com/hypriot/image-builder-rpi  
https://github.com/hypriot/cluster-lab  
https://github.com/hypriot/device-init  
https://github.com/hypriot/flash  

There is also our [Gitter-Chat](https://gitter.im/hypriot/talk) were you'll find a very friendly community that always likes to help.

As always use the comments below to give us feedback and share the news about this release on Twitter, Facebook or Google+.

Govinda [@_beagile__](https://twitter.com/_beagile_)
