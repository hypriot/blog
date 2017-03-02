+++
title = "Building a 64bit Docker OS for the Raspberry Pi 3"
date = "2017-03-02T11:28:42+01:00"
draft = false
more_link = "yes"
Tags = ["Docker","Raspberry Pi","ARM","64bit","ARM64","AARCH64","bee42","Container"]
Categories = ["Docker","Raspberry Pi","ARM","64bit","ARM64","AARCH64","bee42","Container"]

+++

I'm happy to announce the start of a "short" workshop were I'm going through all the steps to build a complete 64bit operating system for the Raspberry Pi 3. This 64bit HypriotOS is mainly focused on running Docker containers easily on this popular DIY and IoT device.

![Raspi3-Image](https://upload.wikimedia.org/wikipedia/commons/e/e6/Raspberry-Pi-3-Flat-Top.jpg)

You'll see that I'm using Docker heavily for each and every build step, because it really helps us a lot to run a local build with [Docker-for-Mac](https://docs.docker.com/docker-for-mac/) or later on the cloud build servers at [Travis CI](https://travis-ci.org).

![bee42-workshop.jpg](/images/building-a-64bit-docker-os-for-rpi3/bee42-workshop.jpg)

This workshop is sponsored by [bee42 solutions](http://bee42.com) <a href="https://twitter.com/bee42solutions" class="twitter-follow-button" data-show-count="false">Follow @bee42solutions</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<!--more-->

### Background and Contents

As you may already know, a complete Linux operating system consists of several important building blocks and I'd like to show you how to build all of these step by step.

For this purpose I'm not going to reinvent the wheel and so I'll reuse all of the existing parts which are already published by the Raspberry Pi Organisation, by the Debian Linux project and will add some more glue code.

At the end you should have learned how to build all the necessary parts and how to automatically create a finished SD card image which could be flashed on an empty SD card. Then boot your Raspberry Pi 3 with and in less than a minute you have a fully running Docker Engine on a Debian-based 64bit Linux OS.

Here is a short overview of the contents of the workshop:

* **Part 1: Bootloader**

* **Part 2: Kernel**

* **Part 3: Root filesystem**

* **Part 4: SD Card Image**

So, that's enough for explaining the background of this workshop. For more informations please follow along the details I'll publish on the coming tweets at Twitter and in the GitHub repos until all the parts of this workshop are finished and available as OpenSource.

Please be aware that this OS is in a development phase and far from being perfect. So you are encouraged to help me with reporting issues and filing pull-requests to add features and fix bugs.


### Further Links

I'm going to publish all the details and steps to build the new operating system in a public GitHub repo. All other details and necessary GitHub repos will be linked here in this section as a future reference.

* **Workshop Repo** https://github.com/bee42/workshop-raspberrypi-64bit-os

So please stay tuned, this link list will be extended over the next few days.


### Acknowledgments

Please follow along the detailed tweets about this workshop via

* [@Quintus23M](https://twitter.com/Quintus23M) <a href="https://twitter.com/Quintus23M" class="twitter-follow-button" data-show-count="false">Follow @Quintus23M</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
* [@HypriotTweets](https://twitter.com/HypriotTweets) <a href="https://twitter.com/HypriotTweets" class="twitter-follow-button" data-show-count="false">Follow @HypriotTweets</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
* [@bee42solutions](https://twitter.com/bee42solutions) <a href="https://twitter.com/bee42solutions" class="twitter-follow-button" data-show-count="false">Follow @bee42solutions</a><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Special thanks goes to [bee42 solutions](http://bee42.com) for giving me the time to work on this awesome topic to build a complete Docker-enabled 64bit OS for the Raspberry Pi 3.

![bee42-logo.jpg](/images/building-a-64bit-docker-os-for-rpi3/bee42-logo.jpg)


### Feedback, please

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Please send us your feedback on our [Gitter channel](https://gitter.im/hypriot/talk) or tweet your thoughts and ideas on this project at [@HypriotTweets](https://twitter.com/HypriotTweets).

Dieter [@Quintus23M](https://twitter.com/Quintus23M)
