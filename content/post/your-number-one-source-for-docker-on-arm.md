+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM", "IoT", "repository", "packagecloud.io", "packages", "downloads"]
date = "2016-03-28T22:00:00+01:00"
draft = false
more_link = "yes"
title = "Your No. 1 source for Docker on ARM"
+++

Besides our [Download section](/downloads/) we do have another source for getting the latest and greatest Docker for ARM.  
It is a debian package repository hosted at [packagecloud.io](https://packagecloud.io/) that contains lots of the stuff from our Download section.

Despite having a package repository for a couple of months now, it seems many people do not know it.
I guess that's our own fault because we never spoke about it - we only added it to our prepared SD card images. :)
Installing or updating Docker or other Docker goodies like Docker-Compose from this repository can be done by a simple `apt-get install`.

In this post I gonna show you what you need to know to get started with this repository.

![Raspberry Pi Workshop in Brussels](/images/packagecloud/packagecloud_io_wide.jpg)

<!--more-->

Packagecloud.io is a really great service for hosting different types of packages (DEBs, RPMs, Ruby Gems).
You get detailed download/usage statistics and can manage all your packages easily with a Web-GUI or with an API.

The last point was what convinced us to use packagecloud.io as it allows us to upload our packages directly from our Continuous Integration systems.
Many popular CI systems offer build-in packagecloud support - for instance Travis or Circle-CI.

Our packagecloud repository is conveniently named "Schatzkiste" and supports Debian-based Linux distributions.

To use it you need to configure 'apt' first by executing:

```
curl -s https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
```

If you want to know what this script does you can look up the [source of this script](https://packagecloud.io/Hypriot/Schatzkiste/install).

It installs 'apt-transport-https' for connecting securely to our repository, adds the packagecloud GPG key to 'apt' and then adds our 'Schatzkiste'-repository sources to '/etc/apt/sources.list.d/Hypriot_Schatzkiste.list'.  
Afterwards it updates the package sources via 'apt-get update'.

From there you are ready to search for the latest Docker via

```
$ apt-cache madison docker-hypriot
docker-hypriot |   1.10.3-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |   1.10.2-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |   1.10.1-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |   1.10.0-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.9.1-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.9.0-2 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.8.3-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.8.2-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.8.1-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.8.0-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.7.1-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.6.2-2 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.6.2-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.6.1-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.6.0-1 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
docker-hypriot |    1.5.0-7 | https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy/main armhf Packages
```

'apt-cache madison' will list all the available version for package 'docker-hypriot' and as you can see the latest Docker 1.10.3 is already there, too.

Install it with

```
$ apt-get install docker-hypriot=1.10.3-1
```

So I want to close this blog post with a huge thank you to the packagecloud.io guys as they are hosting our packages for free.

I highly recommend their service as it can be so tedious and time-consuming to setup your own repository properly - I have been there myself.

As always, use the comments below to give us feedback and share this post on Twitter, Google or Facebook.

Govinda [@\_beagile\_](https://twitter.com/_beagile_)
