+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2016-08-21T12:30:00+02:00"
draft = false
more_link = "yes"
title = "Releasing HypriotOS 1.0.0 \"Blackbeard\""

+++

**Today we proudly present our 1.0.0 release of HypriotOS – a container OS that takes you from Zero to Docker within 5 Minutes only, on any device of the complete Raspberry Pi family.**

For this major release we've taken an especially great deal of trouble. Out of the box, you not only get the breaking features of the Docker Engine 1.12.1 and the latest versions of Docker Compose and Docker Machine, but also many improvements that enhance the performance, reliability and usability.


  ![Raspberry Pi 3](/images/release-1-0/docker_pirate_650px_full-width.jpg)



<!--more-->


Therefore, this release illustrates very much how we work as Hypriot Team: We don't stop after a `docker run` just works on a Raspberry Pi. Meanwhile this has been possible for a long time. We only stop, when we went all the way down the rabbit whole and identified all adjusting screws of the operating system that can be used to improve the **performance, reliability and usability** to run containers efficiently on ARM. Just to name a few examples: we include a Linux Kernel that is optimized for running Docker, we set all recommended configuration settings stated by Docker (and more), and provide tools that make the process of downloading HypriotOS and flashing it on a SD card super easy (see our [flash tool](https://github.com/hypriot/flash) and [device-init](https://github.com/hypriot/device-init)).

As a result, you can be sure that we fine-tuned all adjusting screws to ensure we provide not some container OS, but an awesome one.


## Feature Highlights of HypriotOS

**Latest Docker Engine 1.12.1 with Swarm Mode** </br>
You can get your hands on the new features of the freshly-baked Engine Docker 1.12.1 that is still warm. It includes the new Swarm Mode, which allows high availability of services in a multi-node cluster within just a few commands.
[See this short video how it works.](https://blog.docker.com/2016/07/swarm-mode-on-a-raspberry-pi-cluster/)

**Support for the complete Raspberry Pi family** </br>
You can run HypriotOS on each and every model of the Raspberry Pi family - we're supporting Pi 1, 2, 3, Zero and even the Compute Module. Thus, all Raspberry Pi devices ever built are fully supported. This is possible through the dual kernels for ARMv6 and ARMv7 architecure we included on the SD card. Guess what: you can even switch your SD card from one Pi model to the other and it just works.

**Easy flashing and configuration** </br>
We improved our [flash tool](https://github.com/hypriot/flash), which puts HypriotOS onto a SD card that is ready to boot from with a single command. After you flashed the SD card, you can store the settings of your environment, e.g. Wi-Fi connection parameters into a configuration file on the SD card `/boot/device-init.yaml`. HypriotOS includes [device-init](https://github.com/hypriot/device-init), which makes your Raspberry Pi directly connecting to your Wi-Fi network after booting.
After booting, you can find the Raspberry Pi at your network with a simple `ping black-pearl.local` – no more searching for IP addresses required thanks to the integrated Avahi service discovery.

**Enhanced security out of the box** </br>
We think that security should be shipped out-of-the-box. We make HypriotOS more secure without you even noticing it. For instance, there is no built-in "root" user any more. Also, the default user "pirate" (password "hypriot") is able to run Docker commands directly, which usually requires sudo rights. For an even better security, we strongly recommend to change the default user password and to restrict SSH access to pre-shared keys only with disabling SSH password authentication.

**Maximum performance out of the box** </br>
As with security, running Docker with high performance comes out-of-the-box with HypriotOS. This includes faster booting times (15-17 sec.), an optimized file system to support more Inodes, minimal memory footprint and disk usage, and the reliable overlay storage driver for Docker by default.

**Now 50% smaller in size, even smaller than Raspbian Lite** </br>
Even though HypriotOS 1.0.0 is fully packed with the complete and latest Docker tool set, it now comes at a size smaller than the tiniest version of Raspbian ("Raspbian Lite"). We achieved this mainly by reducing the cache's footprint and leaving out some unused packages, so you won't miss any features you are used to. You just need to download only 232 MB instead of 504 MB as before. With this improvements the minimum disk usage is reduced down to 600 MB.

Please see all details in the [release notes](https://github.com/hypriot/image-builder-rpi/releases/tag/v1.0.0).

## Quick start
**Download our [flash tool](https://github.com/hypriot/flash) and run**
```
flash https://downloads.hypriot.com/hypriotos-rpi-v1.0.0.img.zip
```

**Afterwards, put the SD card into the Raspberry Pi and power it. That's all to get HypriotOS up and running!**


### Next steps

If you wanna connect to the Raspberry Pi, run
```
ssh pirate@black-pearl.local
```
with password "hypriot".

If you want the Raspberry Pi to connect directly to your Wi-Fi after boot, change the hostname of the Raspberry Pi and more, edit `/boot/device-init.yaml` of the SD card and have a look at the [documentation of device-init](https://github.com/hypriot/device-init). Alternatively, checkout the parameters of the [Hypriot flash tool](https://github.com/hypriot/flash) that also allows you to define configurations. Really, it's just so damn easy:
```
flash -n myHOSTNAME -s mySSID -p myWIFIPASSWORD https://downloads.hypriot.com/hypriotos-rpi-v1.0.0.img.zip
```


## Feedback, please

As always, use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Your Hypriot Team:

* Andreas [@firecyberice](https://twitter.com/firecyberice)
* Dieter [@Quintus23M](https://twitter.com/Quintus23M)
* Govinda [@\_beagile\_](https://twitter.com/_beagile_)
* Mathias [@MathiasRenner](https://twitter.com/MathiasRenner)
* Stefan [@stefscherer](https://twitter.com/stefscherer)
