+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-08-22T15:24:03+02:00"
draft = false
more_link = "yes"
title = "Releasing HypriotOS 1.0.0"

+++

**Today we proudly present our 1.0.0 release of HypriotOS – a container OS that takes you from zero to the latest Docker tools within 5 Minutes, on any device of the Raspberry Pi family.**

For this major release we've taken an especially great deal of trouble. Out of the box, you not only get the breaking features of Docker 1.12 and the latest Docker Compose and Machine, but also many improvements that enhance the performance, reliability and usability.

![Raspberry Pi 3](/images/release-1-0/docker_pirate.jpg)

<!--more-->


Therefore, this release illustrates very much how we work as Hypriot Team: We don't stop after a `Docker run` just works on a Raspberry Pi. Meanwhile this has been possible for a long time. We only stop, when we went all the way down the rabbit whole and identified all adjusting screws of the operating system that can be used to improve the **performance, reliability and usability**. Just to name a few examples: we include a Kernel that is optimized for running Docker, we set all recommended configuration settings stated by Docker (and more), and provide tools that make the process of downloading HypriotOS and flashing it on a SD card super easy (see our [flash tool](https://github.com/hypriot/flash) and [device-init](https://github.com/hypriot/device-init)).
As a result, you can be sure that we fine-tuned all adjusting screws to ensure we provide not some container OS, but an awesome one.


## Feature Highlights of HypriotOS

**Latest Docker 1.12.1 with Swarm Mode** </br>
You can get your hands on the new features of the freshly-baked Docker 1.12.1  that is still warm. It includes the new Swarm Mode, which allows high availability of services in a multi-node cluster within just a few commands.
[See this short video how it works.](https://blog.docker.com/2016/07/swarm-mode-on-a-raspberry-pi-cluster/)


**Support for the complete Raspberry Pi family** </br>
Now you can run HypriotOS even on the compute module of the Raspberry Pi family. Thus, all Raspberry Pi devices are now fully supported.

**Easy flashing and configuration** </br>
We improved our [flash tool](https://github.com/hypriot/flash), which puts HypriotOS onto a SD card that is ready to boot from with a single command. After you flashed the SD card, you can store the settings of your environment, e.g. Wi-Fi connection parameters into a file on the SD card `/boot/device-init.yaml`. HypriotOS includes [device-init](https://github.com/hypriot/device-init)), which makes your Raspberry Pi directly connecting to your Wi-Fi network after booting.
After booting, you can find the Raspberry Pi at `black-pearl.local` – No more searching for IP addresses required thanks to the integrated Avahi service discovery.

**Enhanced Security out of the box** </br>
We think that security should be shipped out-of-the-box. We make HypriotOS more secure without you even noticing it. For instance, there is no built-in "root" user any more. Also, the default user "pirate" (password "hypriot") is able to run Docker commands directly, which usually requires sudo rights.

**Maximum Performance out of the box** </br>
As with security, running Docker with high performance comes out-of-the-box with HypriotOS. This includes faster booting times (15-17 sec.), an optimized file system file system to support more Inodes, minimal memory footprint and disk usage, and the reliable overlay storage driver for Docker by default.

**Now 50% smaller in size, even smaller than Raspbian Lite** </br>
Even though HypriotOS is fully packed with the complete Docker tool set, it now comes at a size smaller than the tiniest version of Raspbian. We achieved this mainly by reducing the cache's footprint, thus you won't miss any features you are used to. You just need to download only 232 MB instead of 504 MB as before.

Please see all details in the [release notes](https://github.com/hypriot/image-builder-rpi/releases).

## Quick start
**Download our [flash tool](https://github.com/hypriot/flash) and run**
```
flash https://downloads.hypriot.com/hypriotos-rpi-v1.0.0.img.zip
```

**Afterwards, put the SD card into the Raspberry Pi and power it. That's all to get HypriotOS up and running!**

If you want the Raspberry Pi to connect directly to a Wi-Fi after boot, change the hostname of the Raspberry Pi and more, edit `/boot/device-init.yaml` of the SD card and have a look at the [documentation of device-init](https://github.com/hypriot/device-init). Alternatively, checkout the parameters of the `flash` tool that also allows you to define configurations.

If you wanna connect to the Raspberry Pi, run
```
ssh pirate@black-pearl.local
```
with password "hypriot".


## Feedback, please

As always, use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

[Mathias Renner](@MathiasRenner)
