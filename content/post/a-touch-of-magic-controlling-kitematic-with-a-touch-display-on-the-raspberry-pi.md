+++
Categories = ["Docker", "Raspberry Pi", "ARM", "Kitematic"]
Tags = ["Docker", "Raspberry Pi", "ARM", "Kitematic"]
date = "2015-10-12T00:15:00+02:00"
more_link = "yes"
title = "A touch of magic: Controlling Kitematic & Docker with a touch display on the Raspberry Pi"

galleryprefix = "/images"
galleryfolder = "kitematic-on-pi"
gallerythumbnail = "thumbnails"
+++

We have recently released our [new SD card image](/post/get-your-all-in-one-docker-playground-now-hypriotos-reloaded/) called __Will__.
It is the ultimate Docker playground with Docker Engine, Docker Compose, Docker Swarm and Docker Machine preinstalled.
This image now also supports the new 7" Raspberry Pi Touch Display out-of-the-box. So we thought, wouldn't it be cool to have Kitematic running directly on your Raspberry Pi? And yes, we did it.

![](/images/kitematic-on-pi/teaser.jpg)

<!--more-->

While polishing and testing __Will__ the idea came up that it would be awesome to be able to use Kitematic on the new great [7" touch display of the Raspberry Pi foundation](https://www.raspberrypi.org/blog/the-eagerly-awaited-raspberry-pi-display/).

We started using the [Linux support branch](https://github.com/zedtux/kitematic/tree/linux-support) of Kitematic ([PR #696](https://github.com/kitematic/kitematic/pull/696)) and tried to compile it.
After some fiddling we got the first build working. Still in the team we were not satisfied with installing Kitematic directly on the host - we wanted a better way.
This was the time for the next crazy idea. We thought, let us write a `Dockerfile` to build Kitematic and run it within a Docker container.

{{< gallery title="Kitematic running on the Raspberry Pi" >}}
{{% galleryimage file="docker-toolbox.jpg" size="1600x1200" caption="Unboxing the Docker Toolbox" copyrightHolder="Hypriot" %}}
{{% galleryimage file="display-back.jpg" size="1600x1200" caption="The RPi 2 is attached to 7 inch Raspberry Pi Display" copyrightHolder="Hypriot" %}}
{{% galleryimage file="connect-to-docker-hub.jpg" size="1600x1200" caption="Connect to the Docker Hub" copyrightHolder="Hypriot" %}}
{{% galleryimage file="kitematic.jpg" size="1600x1200" caption="List of Docker Images" copyrightHolder="Hypriot" %}}
{{% galleryimage file="create.jpg" size="1600x1200" caption="Download and create a Docker Container" copyrightHolder="Hypriot" %}}
{{% galleryimage file="web-preview.jpg" size="1600x1200" caption="A running a container with web preview" copyrightHolder="Hypriot" %}}
{{% galleryimage file="thumbs-up.jpg" size="1600x1200" caption="Thumbs up! All is running well" copyrightHolder="Hypriot" %}}
{{< /gallery >}}

{{% galleryinit %}}

You can find the `Dockerfile` in a new GitHub repo at [hypriot/rpi-kitematic](https://github.com/hypriot/rpi-kitematic). If you like you can follow along and try it out with your own display.

We made a small video to demonstrate how Kitematic looks and feels controlling your containers with a touch display:

<div class="video-container"><iframe src="https://www.youtube.com/embed/HVyQeCqE_4A" frameborder="0" allowfullscreen></iframe></div>

As you can see this is still a work-in-progress. But we believe we can make it available soon in an easy and convenient way to be used by everyone.

If you are one of the lucky owners of the new Raspberry 7" touch screen display, you may wanna try out the following steps to run it on your own Pi as well.

First log in to your Raspberry Pi and install X11. We have created a small helper script that installs everything you need.

```
curl -sSL https://github.com/hypriot/x11-on-HypriotOS/raw/master/install-x11-basics.sh | bash
```

Now you have to enable the X11 server to listen on a TCP socket (port 6000). Just insert the line `xserver-allow-tcp=true` in the file `/etc/lightdm/lightdm.conf`.

```
echo "xserver-allow-tcp=true" >> /etc/lightdm/lightdm.conf
```

Next you have to enable X11 server to accept external TCP access from inside of a Docker container.
This is a network connection coming from another TCP/IP address because the container is running in it's own network name space.

If you want to automate this step, you can add a start script so the TCP connections are allowed after the next reboot.
If you want to do it manually, just skip this step.

```
echo "xhost +" > /etc/X11/Xsession.d/36x11-xhost-docker
```

To fix the orientation of the 7" touch display we have to add `lcd_rotate=2` into the `/boot/config.txt`. If you just use an HDMI monitor you should skip this step.

```
echo "lcd_rotate=2" >> /boot/config.txt
```

Now reboot your Pi to start the X11 server on your 7" touch display or HDMI monitor.

```
reboot
```

If you haven't enabled the TCP connection yet, run the following command to enable it now.

```
DISPLAY=:0.0 xhost +
```

If it works you see a message like `access control disabled, clients can connect from any host`.

Now you have to build the Kitematic container.
We haven't uploaded it to the Docker Hub yet as it is still a work-in-progress.

```
git clone https://github.com/hypriot/rpi-kitematic
cd rpi-kitematic
docker build -t hypriot/rpi-kitematic .
```

Now it's time to run the Kitematic container with:

```
docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -e DISPLAY=172.17.42.1:0.0 hypriot/rpi-kitematic
```

The container runs Kitematic in development mode. Because of this the first start-up may take some minutes until the user interface finally shows up.
But once it is started, it feels pretty smooth to use.

I hope you enjoyed this demonstration. We currently think of how to best deploy Kitematic for the Pi - whether we should run it in a container or natively on the host.
But running a GUI application in a Docker container was something we wanted to try out anyhow. :)

What do you think would be the best approach? How should we provide Kitematic on a Raspberry Pi without putting to much bloat into our SD card image by default?

As always use the comments below to give us feedback and share it on Twitter or Facebook.
You also might wanna discuss this article on [HackerNews](https://news.ycombinator.com/item?id=10374271) or vote it up if you find it interesting.

Stefan
