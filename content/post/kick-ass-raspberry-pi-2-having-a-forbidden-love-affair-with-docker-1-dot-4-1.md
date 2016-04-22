+++
Categories = ["docker", "raspberry_pi"]
Tags = ["docker", "raspberry_pi", "release"]
date = "2015-02-08T22:09:33+01:00"
title = "Kick-Ass Raspberry Pi 2 having a forbidden love affair with Docker 1.4.1"
aliases = [ "kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1" ]

disqus_url = "http://blog.hypriot.com/post/kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1"
disqus_title = "Kick-Ass Raspberry Pi 2 having a forbidden love affair with Docker 1.4.1"

tweet_url = "http://blog.hypriot.com/kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1"
facebook_url = "http://blog.hypriot.com/kick-ass-raspberry-pi-2-having-a-forbidden-love-affair-with-docker-1-dot-4-1"

more_link = "yes"

galleryprefix = "http://assets.hypriot.com/gallery"
galleryfolder = "forbidden-love-affair"
gallerythumbnail = "thumbnails"
+++

If you have not been living under a rock last week you probably heard that the [Raspberry Pi Foundation](http://www.raspberrypi.org/) did release a second generation Raspberry Pi on the 2th of February.

The last generation being a huge success with 4 million devices sold at the end of 2014 the success story is likely to continue with a new Raspberry Pi 2 Model B in 2015.

Pi 2 has the same form factor as the previous Pi 1 Model B+ and is completely compatible with Pi 1 - which is good news for everybody who already owns a Pi 1. Your old equipment will most likely still work with the Pi 2.

{{< gallery title="Raspberry Pi 2 Images" >}}
{{% galleryimage file="hypriot_pi2_01.jpg" size="1600x900" caption="Pi 2 front and its package" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi2_02.jpg" size="1600x900" caption="Pi 2 backside" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi2_03.jpg" size="1600x900" caption="Pi 2 front" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi2_04.jpg" size="1600x900" caption="Pi 2" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi2_05.jpg" size="1600x900" caption="Pi 2" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi2_06.jpg" size="1600x900" caption="Pi 2" copyrightHolder="Hypriot" %}}
{{< /gallery >}}

Looking at the Pi 2 the most obvious difference is that it features a 900MHz quad-core ARM Cortex-A7 CPU with 1 GB of RAM. Because it has an ARMv7 processor it can now run the full range of ARM GNU/Linux distributions. Early benchmarks promise a performance boost of 4 to 6 times faster compared to the old single core Pi.

The Pi 2 can be bought from various places like [RS Online](http://uk.rs-online.com/web/p/processor-microcontroller-development-kits/8326274/) in the UK or [Pollin](http://www.pollin.de/shop/dt/Mzg1NzkyOTk-/Bausaetze_Module/Entwicklerboards/Raspberry_Pi_2_Model_B.html) in Germany.

Luckily we have been able to get our hands on a brand new Pi 2 before the first charge was sold out. Being such a performance beast we were really curious how well it would play with one of our other passions - [Docker](https://www.docker.com/). Docker really is a terrific way to easily deploy all kinds of applications on your device without the need of being a full-sized linux administrator.

Well - after some tinkering we got Pi 2 and Docker playing well together really fast. Based on the most recent Raspbian we compiled our own special kernel and Docker packages. We then combined these into a lean and sexy image that can be easily flashed to a SD-Card.

What is really awesome about this image is not only that it combines two of the hottest technologies in 2015 into a single package but that it uses the most recent versions of those technologies.

The image uses

- Raspbian __Wheezy__
- Linux Kernel __3.18.6__
- Docker __1.4.1__ with __OverlayFS__

Our first tests went really well and we could do all the basic Docker stuff with the image. Our first impression is that running Docker on the Pi 2 promises to be a much smoother experience than on the Pi 1. Certainly there will be some areas where we still need to iron out some kinks with the image but so far it seems to be pretty solid.

{{< gallery title="Docker in action with Raspberry Pi 2" >}}
{{% galleryimage file="hypriot_pi_uname.jpg" size="986x540" caption="Command 'docker images'" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi_docker_info.jpg" size="986x540" caption="Command 'docker images'" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi_docker_images.jpg" size="986x540" caption="Command 'docker images'" copyrightHolder="Hypriot" %}}
{{% galleryimage file="hypriot_pi_docker_run.jpg" size="986x540" caption="Command 'docker images'" copyrightHolder="Hypriot" %}}
{{< /gallery >}}

{{% galleryinit %}}

We really would like to see how our image works for others and that is why you can download it here:

[Docker-Pi-Image](http://downloads.hypriot.com/hypriot-rpi-20150208-015447.zip) (~400MB)

__Update (30.03.2015):__ We have published a more [recent version of our SD card image](http://blog.hypriot.com/post/hypriotos-back-again-with-docker-on-arm).

Tell us what you like or dislike about this image!

We will gather your feedback and will try to make this image even better. Additionally we are also planning to publish our build scripts for the image soon.

Did I already tell you what the real kicker is?

Well - our image works for __Pi 1 & 2__ at the same time. How convenient is that?!

__The credentials for logging in are "root" for the user and "hypriot" for the password.__ Have fun!
