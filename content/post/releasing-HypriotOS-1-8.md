+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM"]
date = "2018-03-27T16:30:00+02:00"
draft = false
more_link = "yes"
title = "Releasing HypriotOS 1.8.0: Raspberry Pi 3 B+, Stretch and more"
+++

**We're proud to announce our 1.8.0 release of HypriotOS - the fasted way to get Docker up and running on any Raspberry Pi including the new Pi 3 B+.**

At this years Pi day the Raspberry Pi foundation [has announced a new model](https://www.raspberrypi.org/blog/raspberry-pi-3-model-bplus-sale-now-35/) - the Raspberry Pi 3 B+ with improved networking and a faster CPU. A good reason for us to update our HypriotOS to support this new device. And while we were at it we also updated the OS to Raspbian Stretch and Linux Kernel version 4.9.80 - and of course the latest Docker 18.03.0-ce release.

![Raspberry Pi 3 B+](/images/release-1-8/pi3-b-plus.jpg)

<!--more-->

## Features of HypriotOS

**Latest Docker Engine 18.03.0-ce with Swarm Mode** </br>
You can use the latest features of the freshly-baked Engine Docker 18.03.0-ce that is still warm. It includes the Swarm Mode, which allows high availability of services in a multi-node cluster within just a few simple commands.
[See this short video how it works.](https://blog.docker.com/2016/07/swarm-mode-on-a-raspberry-pi-cluster/)

**Up to date with Raspbian Lite** </br>
You can run HypriotOS with an up-to-date OS and Linux kernel which is in sync with Raspbian Lite. We have updated to Raspbian Stretch and also prepared a new Docker optimized kernel 4.9.80.

**Support for the complete Raspberry Pi family** </br>
You can run HypriotOS on every model of the Raspberry Pi family - we're supporting Pi 1, 2, 3, the 3 B+, Zero and even the Compute Module.

**Easy flashing and configuration** </br>
We improved our [flash tool](https://github.com/hypriot/flash), which puts HypriotOS onto a SD card that is ready to boot from with a single command. With additional command line options you can customize HypriotOS during the flash operation to have the best out-of-the-box first-boot experience.
HypriotOS includes [cloud-init](http://cloudinit.readthedocs.io/en/0.7.9/), which makes the first boot of your Raspberry Pi customizable and you even are able connecting it to your Wi-Fi network during boot.
After booting, you can find the Raspberry Pi at your network with a simple `ping black-pearl.local` – no more searching for IP addresses required thanks to the integrated Avahi service discovery.

**Enhanced security out of the box** </br>
We think that security should be shipped out-of-the-box. We make HypriotOS more secure without you even noticing it. For instance, there is no built-in "root" user. Also, the default user "pirate" (password "hypriot") is can be customized or removed before the first boot. Just look at the file `/boot/user-data`. You can add your public SSH key, disable password logins and specify a different user account before you even boot your Raspberry Pi. WiFi can be customized and enabled to have Docker up and running through the air without attaching a keyboard and monitor.

**Smaller than Raspbian Lite** </br>
Even though HypriotOS 1.8.0 is fully packed with the complete and latest Docker tool set, it now comes at a size smaller than the tiniest version of Raspbian ("Raspbian Lite").

Please see all details in the [release notes](https://github.com/hypriot/image-builder-rpi/releases/tag/v1.8.0).

## Quick start

**Download our [flash tool](https://github.com/hypriot/flash)**

```
curl -O https://raw.githubusercontent.com/hypriot/flash/2.0.0/flash
chmod +x flash
sudo mv flash /usr/local/bin/flash
```

**Now run this command to flash HypriotOS 1.8.0**

```
flash https://github.com/hypriot/image-builder-rpi/releases/download/v1.8.0/hypriotos-rpi-v1.8.0.img.zip
```

**Afterwards, put the SD card into the Raspberry Pi and power it. That's all to get HypriotOS up and running!**

### Next steps

If you want to connect to the Raspberry Pi, run

```
ssh pirate@black-pearl.local
```

with password "hypriot".

If you want the Raspberry Pi to connect directly to your Wi-Fi after boot, change the hostname of the Raspberry Pi and more, edit `/boot/user-data` of the SD card and have a look at [our FAQ](https://blog.hypriot.com/faq/#wifi). Alternatively, checkout the parameters of the [Hypriot flash tool](https://github.com/hypriot/flash) that also allows you to define your own cloud-init user-data template file which will be copied onto the SD image for you:

```
flash -n myHOSTNAME -u wifi.yml https://github.com/hypriot/image-builder-rpi/releases/download/v1.8.0/hypriotos-rpi-v1.8.0.img.zip
```

We will improve the flash tool to bring back support of the `-s` and `-p` options so you can add WiFi support without creating your own user-data template file.

## Hands-free projects

We have put together a small sample YAML that shows what you can do with HypriotOS, cloud-init and Docker. You can prepare a wireless Raspberry Pi with an SD card image that creates a Docker Swarm and starts a service to drive some LED's automatically. You don't have to login to this device. It will also start the service again after a power outage.

The sample [rainbow.yml](https://github.com/hypriot/flash/blob/master/sample/rainbow.yml) shows how to setup a user with SSH public key authentication, activate WiFi and run a rainbow service.
You only have to customize the YAML file at

* line 16: insert your SSH public key for authentication
* line 32 and 33: insert your WiFi settings

Then flash an SD image with this command

```
flash -u rainbow.yml https://github.com/hypriot/image-builder-rpi/releases/download/v1.8.0/hypriotos-rpi-v1.8.0.img.zip
```

And after booting a Raspberry Pi Zero or Pi 3/Pi 3 B+ you will see some blinking LED's after some minutes.

![Raspberry Pi 3 B+ with rainbow service](/images/release-1-8/rainbow.jpg)

## Feedback, please

As always, use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

* Stefan [@stefscherer](https://twitter.com/stefscherer)
