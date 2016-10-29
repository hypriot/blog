+++
Categories = ["docker"]
Description = "Getting started with Docker on your Raspberry Pi"
Tags = ["hypriotos", "docker", "arm", "raspberry_pi", "getting_started"]
title = "Getting started with Docker on your Raspberry Pi"
aliases = [ "getting-started" ]
date = "2015-05-15T20:16:11+02:00"
disqus = "yes"
social_sharing = "yes"
+++

Docker is a new technology that emerged in the last two years and took the software world by storm. What exactly is Docker and why did it became so popular in such short time?

The goal of this guide is to answer these questions and to get you started with Docker on a Raspberry Pi in no time.
We are going to cover the procedure for Windows, OS X and Linux users.


## What the heck is Docker and why would I use it?
Docker simplifies the packaging, distribution, installation and execution of (complex) applications.

In this context, applications are:

- blogging platforms like [Wordpress ](https://wordpress.com) or [Ghost](https://ghost.org/)
- tools for software collaboration like [Gitlab](https://about.gitlab.com/) or [Gogs](http://gogs.io/)
- file synchronization platforms like [OwnCloud](https://owncloud.org/) or [Seafile](http://seafile.com/en/home/)

These kinds of applications usually consist of many components which need to be installed and configured. This is often a time consuming and frustrating experience for users.

Docker allows administrators or developers to package these applications into something called containers.
Containers are self-contained, preconfigured packages that a user can fetch and run with just a single command.
By keeping different software components separated in containers they can also be easily updated or removed without influencing each other.
There are many more advantages of using Docker; the details of which can be found in the official [Docker Documentation](https://docs.docker.com).

## The Raspberry Pi: An easy, low cost way of getting started with Docker
If we piqued your curiosity and you would like to dive into the magic world of Docker one of the easiest ways is by using Docker on a [Raspberry Pi](https://www.raspberrypi.org/help/what-is-a-raspberry-pi/).
According to the creators of the Raspberry Pi it is:

> a low cost, credit-card sized computer that plugs into a computer monitor or TV, and uses a standard keyboard and mouse.
It is a capable little device that enables people of all ages to explore computing, and to learn how to program in languages like Scratch and Python.
It’s capable of doing everything you’d expect a desktop computer to do, from browsing the internet and playing high-definition video, to making spreadsheets, word-processing, and playing games.

The goal of this guide is to show you the necessary steps to get you started with Docker on a Raspberry Pi. Please follow the guide that covers your operating system and continue below once you have finished.

-> [The Windows guide for setting up Docker on a Raspberry Pi](/getting-started-with-docker-and-windows-on-the-raspberry-pi)

-> [The Mac OS X guide for setting up Docker on a Raspberry Pi](/getting-started-with-docker-and-mac-on-the-raspberry-pi)

-> [The Linux guide for setting up Docker on a Raspberry Pi](/getting-started-with-docker-and-linux-on-the-raspberry-pi)



## Going wild with Docker! What can you actually do with it?
As stated in the beginning Docker simplifies the way software is distributed and run. We even said that you would only need one command for that. It is time to prove it.

Just type `docker run` into the terminal of your Raspberry Pi:

```
docker run -d -p 80:80 hypriot/rpi-busybox-httpd
```

This command will download and start the Docker image *hypriot/rpi-busybox-httpd* which contains a tiny webserver. Once an image is started it is called a *container*. An image can also be used to start multiple containers.
You can check if your container is running by typing

```
docker ps
```

You should see the container you just started in the container list.

Now you can open up your browser on your workstation and type in the IP address of your Raspberry Pi to see that it really works!

![hypriot-logo](https://assets.hypriot.com/blog_post_getting-started/browser-pi-hypriot-logo.png)

One great aspect of running a Docker-based app is, you can be sure that it works on every machine running Docker with one exception.

Here we run Docker on a Raspberry Pi. So the CPU architecture here is **ARM** rather than x86/x64 by Intel or AMD. Thus, Docker-based apps you use have to be packaged specifically for ARM architecture! Docker-based apps packaged for x86/x64 will not work and will result in an error such as:

```
FATA[0003] Error response from daemon: Cannot start container 0f0fa3f8e510e53908e6a459e817d600b9649e621e7dede974d6a65761ad39e5: exec format error
```

Keep this in mind when searching for apps on the [Docker Hub](https://registry.hub.docker.com/search?q=library) - **the source** for Docker apps/images. If you see the keyword *RPI* or *ARM* in the heading or description, this app can usually be used for the Raspberry Pi.

We prepared a couple of [Raspberry Pi ready images](https://hub.docker.com/u/hypriot/) for your convenience. Try them out now and have fun!

<a href="https://registry.hub.docker.com/search?q=hypriot&searchfield=">![dockerhub-hypriot-search](https://assets.hypriot.com/blog_post_getting-started/dockerhub-hypriot-search.png)</a>
