+++
Categories = ["hypriotos"]
Tags = ["hypriotos", "docker", "arm", "open-vswitch", "raspberry_pi", "release"]
date = "2015-03-30T00:00:00+02:00"
more_link = "yes"
title = "HypriotOS: Back Again and Better then Ever"
aliases = [ "post/back_again" ]
disqus_url = "https://blog.hypriot.com/post/back_again"

+++
Time is running and it is nearly a month since we released our last ARM Docker SD card image for the Raspberry Pi.
Listening to our users and having some ideas of our own we are back again with our latest version of HypriotOS.

We dubbed it "__Jack__" as every proper software release should have a fitting [code name](http://royal.pingdom.com/2010/05/27/the-developer-obsession-with-code-names-114-interesting-examples/).
<!--more-->

## Summary of Changes
Jack brings along a host of new features

- an upgrade of the Linux kernel from 3.18.8 to __3.18.10__
- support for [Open vSwitch](http://openvswitch.org/)
- support for __network hotplugging__
- out of the box support for __Wifi__
- support for __Avahi__ (aka Apple Bonjour)
- more inodes to allow for more files in the filesystem
- some smaller improvements/additions: fake-hwclock, usbutils, htop

Some of these feature deserve a more thorough explanation.

### Open vSwitch support
Check out this cool video [Running Open vSwitch on Docker](https://www.youtube.com/watch?v=sBy0NVBPc9g) from Dave Tucker as an introduction to Docker and Open vSwitch.
We added the foundation for using Open vSwitch by adding the necessary kernel support into our image.

You can see for yourself by typing the following

{{< highlight text >}}
HypriotOS: root@black-pearl in ~
$ modprobe openvswitch
HypriotOS: root@black-pearl in ~
$ lsmod | grep openvswitch
openvswitch            68194  0
vxlan                  29211  1 openvswitch
gre                     4069  1 openvswitch

{{< /highlight >}}

Be aware that you still need a working Open vSwitch Docker image that works for ARM.
If nobody else is faster we might provide one soon ourselves!


### Improved Networking Support

#### Hotplug
To make the networking with our image a smoother experience we added hotplug support for networking devices.
This allows you to add for instance a USB Wifi Dongle and it will be recognized by your Pi at once.

You can check if it worked by using __lsusb__:

{{< highlight text >}}

$ lsusb
Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp.
Bus 001 Device 004: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 802.11n WLAN Adapter
{{< /highlight >}}

#### Wifi
One of the most asked for features regarding our SD image was the support of Wifi.

The easiest way to get started with Wifi is on Mac with our [flash script](https://github.com/hypriot/flash).
This script does not only allow you to set Wifi configuration but it also allows you to fetch, configure and flash the SD card in one go.

{{< highlight text >}}

flash --ssid Your-Wifi-SID --password Your-Wifi-Password http://downloads.hypriot.com/hypriot-rpi-20150329-140334.img.zip

{{< /highlight >}}

If you cannot use our nifty flash tool you have to first boot your Pi with a network cable attached.
Then you can add your Wifi credentials in `/boot/occidentalis.txt` as described in the [Readme](https://github.com/hypriot/flash#occidentalistxt) of the flash tool.
Afterwards run `occi` at the command line and reboot.

After rebooting you should see a wlan-interface with an ip address assigned similar to this:

{{< highlight text >}}

$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
    link/ether b8:27:eb:c0:df:1a brd ff:ff:ff:ff:ff:ff
    inet 192.168.178.83/24 brd 192.168.178.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::ba27:ebff:fec0:df1a/64 scope link
       valid_lft forever preferred_lft forever
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether e8:4e:06:0b:bf:d8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.178.144/24 brd 192.168.178.255 scope global wlan0
       valid_lft forever preferred_lft forever
    inet6 fe80::ea4e:6ff:fe0b:bfd8/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN
    link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
    inet 172.17.42.1/16 scope global docker0
       valid_lft forever preferred_lft forever

{{< /highlight >}}

### Support for Avahi/Bonjour
One of the major problems after booting your Pi always was how to find out its IP address.
There are many approaches to solve this problem but one of the easiest is with the help of [Avahi](http://de.wikipedia.org/wiki/Avahi_(Software).

Now after booting up our SD card image you can just ssh into your Pi without finding out the IP address first.

{{< highlight text >}}
$ ssh root@black-pearl.local
root@black-pearl.local's password:
Linux black-pearl 3.18.10-hypriotos-v7+ #2 SMP PREEMPT Sun Mar 29 13:13:41 UTC 2015 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sun Mar 29 23:49:43 2015 from macbook
HypriotOS: root@black-pearl in ~
$
{{< /highlight >}}

__black-pearl__ is the standard hostname your Pi gets after booting with our image.

This out of the box experience is once again unfortunately only for Mac users.
Linux and Windows users need to install additional software first.

Linux users need to install the Avahi daemon. For Ubuntu it works like this

`sudo apt-get install avahi-daemon`

Windows users need to install [iTunes](https://www.apple.com/de/itunes/download/) as Bonjour/Avahi comes bundles with it.

## Download
The new image can be downloaded here:

[Docker-Pi Image](http://downloads.hypriot.com/hypriot-rpi-20150329-140334.img.zip) (~367MB)  
[SHA256 checksum](http://downloads.hypriot.com/hypriot-rpi-20150329-140334.img.zip.sha256)

## How to get started
Download our SD card image and flash it on your own SD card. [Here](http://computers.tutsplus.com/articles/how-to-flash-an-sd-card-for-raspberry-pi--mac-53600) is a short guide on how to do this for Mac, Windows and Linux users. Afterwards insert the SD card in your Raspberry Pi and wait while it boots. The first time will take a little longer as it resizes the file system to its maximum and reboots again.

At the boot prompt log in with user "__pi__" and password "__raspberry__" (or with a privileged user "root" and password "hypriot").

One thing that is still worth mentioning is that you need special ARM-compatible Docker Images.
__Standard x86-64 Docker Images from the Docker Hub won't work__. That's the reason why we've created a number of ARM compatible Docker Images to get you started. Wether you prefer Java, Python, Node.js or io.js - we have you covered!

You can find these images and more at [our place](https://registry.hub.docker.com/repos/hypriot/) on the Docker Hub. After booting our image on your Pi these base images are just a "docker pull" away. For example "docker pull hypriot/rpi-node".

## Give us your feedback
As we want to make this image even better we really need your feedback. What do you like about our SD card image and what could be made better? And what kind of additional Docker Images would you like to see?

Tell us via Twitter, HackerNews or in the comments!
And please share this post with your friends.

We really would like to see more people using Docker on Raspberries as we think they make a really hot combo:
Low-cost instant access to Docker awesomeness on your Raspberry Pi.
