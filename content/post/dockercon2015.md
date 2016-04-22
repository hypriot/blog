+++
Categories = ["Docker", "Raspberry Pi", "ARM", "DockerCON 2015", "DockerCON2015"]
Tags = ["Docker", "Raspberry Pi", "ARM", "DockerCON"]
Description = "Hypriot-Demo and challenge at DockerCon 2015 - 1.000 containers on a small ARM device"
aliases = [ "dockercon" ]
date = "2015-06-24T01:30:34+02:00"
more_link = "yes"
title = "Hypriot-Demo and challenge at DockerCon 2015"
disqus = "yes"
social_sharing = "yes"

galleryprefix = "/images"
galleryfolder = "dieter_at_dockercon"
gallerythumbnail = "thumbnails"


+++
Hypriot had a short demo session (16:45 - 17:15 PDT) on the second day of the DockerCon 2015 in San Francisco,CA (USA).
The goal of the demo was to show that Docker is a really lightweight "virtualization" solution that can be easily run on small IoT devices.

<!--more-->

{{< gallery title="Dieter Reuter from the Hypriot team at DockerCon 2015" >}}
{{% galleryimage file="dieter_hypriot_dockercon_2015_1.png" size="1426x804" caption="It's fun because the demo actually works fine :-)" copyrightHolder="Docker Inc." %}}
{{% galleryimage file="dieter_hypriot_dockercon_2015_2.png" size="1430x802" caption="7 minutes have passed and 250 container have been started..." copyrightHolder="Docker Inc." %}}
{{% galleryimage file="dieter_hypriot_dockercon_2015_3.png" size="1428x806" caption="Get on our blog and start with the #hypriot_docker_challenge!" copyrightHolder="Docker Inc." %}}
{{< /gallery >}}

{{% galleryinit %}}

<iframe src="https://player.vimeo.com/video/131966874" width="600" height="450" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="https://vimeo.com/131966874">DockerCon2015 - Scale down to the minimum</a> from <a href="https://vimeo.com/user38425431">hypriot</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

As preparation for this demo we only had to make some small [tweaks](https://github.com/docker/docker/compare/master...hypriot:optional_userland_proxy) to Docker and its environment.
These changes allowed us to start up hundreds of containers on a Raspberry Pi in just a couple of minutes. How awesome is that?
If that is possible on a small device imagine how Docker runs on a big server... :)

### The Hypriot-DockerCon-Challenge
Even with this jaw-dropping result we think there is room for improvement.
That is why __we challenge you__ to help us to improve the performance even more and remove remaining roadblocks!

**Prize:**

The person who successfully manage to get the highest number of these [Docker containers](https://registry.hub.docker.com/u/hypriot/rpi-busybox-httpd/) to run concurrently on a Raspberry Pi 2 will be awarded a [DockerCon Europe](http://europe.dockercon.com) ticket and a speaking / demo slot during the conference.

**Rules:**

1. Use a single Raspberry Pi 2 with a HypriotOS release (a Raspi 1 would work too, but you’ll have a big disadvantage with 512MByte only)
2. Use Docker Engine to start the containers (see technical hint #3 below)
3. Use the webserver container “hypriot/rpi-busybox-httpd” as a starting point – you can use whatever webserver you like, but you have to serve the static website with the same index.html + .jpg
4. Challenge ends on Monday, October 19th, 2015 at 17:00 PDT – winner will be announced on Tuesday, October 20th

**Technical Hints:**

1. Reduce the stack size used for starting Docker subprocesses (see /etc/init.d/docker)
2. Optimize the httpd container in order to use less memory
3. Optimize the Docker daemon itself (Participants must submit any changes made to docker engine with appropriate tests back to the docker project or must be independently reproducible with the stock docker engine release.) Optimizations must be general optimizations, useful outside of the scope of this specific benchmark.
4. Ask Hypriot for help, they’ll offer new hints and tips publicly through comments on the blog and [Twitter](https://twitter.com/HypriotTweets)


To get you started for this challenge we prepared a couple of links for you:

- [Getting started with our Docker Hypriot SD-card image on Raspberry Pi](http://blog.hypriot.com/getting-started)
- [Raspberry Pi Docker Image for HTTPd](https://github.com/hypriot/rpi-busybox-httpd)
- [Start-Script for running lots of containers on the Raspberry Pi](https://github.com/hypriot/rpi-busybox-httpd/blob/master/start-webservers.sh)

Hope we did wet your appetite. Happy hacking and have fun!

As always use the comments below to give us feedback and share it on Twitter or Facebook.
