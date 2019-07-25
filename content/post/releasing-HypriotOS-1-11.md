+++
Categories = ["Docker", "Raspberry Pi", "ARM", "hypriotos"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2019-07-25T06:31:00+02:00"
draft = false
more_link = "yes"
title = "Releasing HypriotOS 1.11.0: Docker 19.03.0 CE from Raspberry Pi Zero to 4 B"
+++

**We're proud to announce our 1.11.0 release of HypriotOS - the fastest way to get Docker up and running on any Raspberry Pi.**

![Raspberry Pi 4 B](/images/release-1-11/raspberry-pi-4-b.jpg)

<!--more-->

## Features of HypriotOS

**Latest Docker Engine 19.03.0 Community Edition** </br>
You can use the latest features of the freshly-baked Docker Engine 19.03.0 that is still warm. It includes the Swarm Mode, which allows high availability of services in a multi-node cluster within just a few simple commands.

**Up to date with Raspbian Lite Buster** </br>
You can run HypriotOS with an up-to-date OS and Linux kernel which is in sync with the current Raspbian Lite Buster running a Linux kernel 4.19.58.

**Support for the complete Raspberry Pi family** </br>
You can run HypriotOS on every model of the Raspberry Pi family - we're supporting Pi 1, 2, 3, the 3 B+, Zero and even the Compute Module and the new Raspberry Pi 4 B.

**Easy flashing and configuration** </br>
We improved our [flash tool](https://github.com/hypriot/flash), which puts HypriotOS onto a SD card that is ready to boot from with a single command. With additional command line options you can customize HypriotOS during the flash operation to have the best out-of-the-box first-boot experience.
HypriotOS includes [cloud-init](https://cloudinit.readthedocs.io/en/18.3/), which makes the first boot of your Raspberry Pi customizable and you even are able connecting it to your Wi-Fi network during boot.
After booting, you can find the Raspberry Pi at your network with a simple `ping black-pearl.local` – no more searching for IP addresses required thanks to the integrated Avahi service discovery.

**Enhanced security out of the box** </br>
We think that security should be shipped out-of-the-box. We make HypriotOS more secure without you even noticing it. For instance, there is no built-in "root" user. Also, the default user "pirate" (password "hypriot") is can be customized or removed before the first boot. Just look at the file `/boot/user-data`. You can add your public SSH key, disable password logins and specify a different user account before you even boot your Raspberry Pi. WiFi can be customized and enabled to have Docker up and running through the air without attaching a keyboard and monitor.

**Smaller than Raspbian Lite** </br>
Even though HypriotOS 1.11.0 is fully packed with the complete and latest Docker tool set, it now comes at a size smaller than the tiniest version of Raspbian ("Raspbian Lite").

Please see all details in the [release notes](https://github.com/hypriot/image-builder-rpi/releases/tag/v1.11.0).

## Quick start

**Download our [flash tool](https://github.com/hypriot/flash)**

```
curl -O https://raw.githubusercontent.com/hypriot/flash/2.3.0/flash
chmod +x flash
sudo mv flash /usr/local/bin/flash
```

**Now run this command to flash HypriotOS 1.11.0**

```
flash https://github.com/hypriot/image-builder-rpi/releases/download/v1.11.0/hypriotos-rpi-v1.11.0.img.zip
```

**Afterwards, put the SD card into the Raspberry Pi and power it. That's all to get HypriotOS up and running!**

### Next steps

If you want to connect to the Raspberry Pi, run

```
ssh pirate@black-pearl.local
```

with password "hypriot".

### Flash with Wi-Fi settings for Pi Zero / Pi 3 / Pi 4

If you want the Raspberry Pi Zero (or Pi 3 or Pi 4) to connect directly to your Wi-Fi after boot, change the hostname of the Raspberry Pi and more, edit `/boot/user-data` of the SD card and have a look at [our FAQ](https://blog.hypriot.com/faq/#wifi). Alternatively, checkout the parameters of the [Hypriot flash tool](https://github.com/hypriot/flash) that also allows you to define your own cloud-init user-data template file which will be copied onto the SD image for you:

```
flash -n myHOSTNAME -u wifi.yml https://github.com/hypriot/image-builder-rpi/releases/download/v1.11.0/hypriotos-rpi-v1.11.0.img.zip
```

## Feedback, please

As always, use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

