+++
Categories = ["docker", "raspberry_pi"]
Tags = ["docker", "raspberry_pi"]
date = "2016-10-31 15:18:33+01:00"
title = "Visualize your Raspberry Pi containers with Portainer or UI for Docker"
author = "Stefan Scherer"

more_link = "yes"
+++

At home I use some Raspberry Pi's for some home network services, and I run
these services inside Docker containers. From time to time I want to see or
manage one of these containers. But I'm too lazy to get to my laptop and use
the Docker CLI for that. There are two nice Docker UI's to access your Docker engine with a web browser. Let's have a look at both.

![Portainer](/images/dockerui-portainer/portainer-docker.png)

<!--more-->

## UI for Docker, formerly known as DockerUI

I have started using the DockerUI, an open source project from Michael Crosby and Kevan Ahlquist. You can find the source code on GitHub at https://github.com/kevana/ui-for-docker.

In [my home setup](https://github.com/StefanScherer/docker-at-home/blob/eb451b954809393e8536259aff6daf27bfb7b7b8/docker-compose.yml#L27-L35
) I use Docker Compose to configure how to run my services.

This is my configuration to start the UI so I can reach it on port 80 of the Raspberry Pi.

```yaml
ui:
  image: hypriot/rpi-dockerui
  restart: always
  volumes:
    - '/var/run/docker.sock:/var/run/docker.sock'
  expose:
    - 9000
  ports:
    - 80:9000
```

As you can see we provide a Docker image [hypriot/rpi-dockerui](https://hub.docker.com/r/hypriot/rpi-dockerui/) on the Docker hub so it is very easy to use it in your environment.

So let's have a look at the dashboard which shows you an overview of your running or stopped containers:

 ![DockerUI Dashboard](/images/dockerui-portainer/dockerui-dashboard.png)

You can click on each container and see more details and so some actions with them like stopping and starting them again.

![DockerUI Container](/images/dockerui-portainer/dockerui-container.png)

The UI provides some more views to list for example all local Docker images and information about your Docker engine.

![DockerUI Images](/images/dockerui-portainer/dockerui-images.png)

## Portainer

Last week I found [portainer.io](http://portainer.io) which also looks very good. They provide Docker images for Linux and Windows, but not for ARM right now.

The source code is also available on GitHub https://github.com/portainer/portainer and it's based on the work of DockerUI.

As there is no Linux ARM version for it, I just sent them a [pull request](https://github.com/portainer/portainer/pull/299) to add support for it.
In the meantime we provide a Docker image for the Rapsberry Pi at [hypriot/rpi-portainer](https://hub.docker.com/r/hypriot/rpi-portainer/).

Just use the same Docker Compose sample from above and replace the image name. Killing the old container and running a new one with `docker-compose up -d ui` you have Portainer up and running.

The dashboard also gives you an overview of all running containers, all images etc.

![Portainer Dashboard](/images/dockerui-portainer/portainer-dashboard.png)

In the container list you can see all running and stopped containers as well as some actions you can do with it.

![Portainer Dashboard](/images/dockerui-portainer/portainer-container.png)

Clickin on one of the running containers you have access to the details, environment variables, port mappings, volumes.
You can also access some CPU/memory and network statistics as well as the logs of your container, as well as the processes running inside the container.

![Portainer Stats](/images/dockerui-portainer/portainer-stats.png)

## Conclusion

If you want to remote control your Raspberry Pi Docker containers from a nice Web UI, then try
one of these prebuilt Docker images. Of course be aware that everyone in your home network
is able to manipulate your Docker containers with it as there is no login dialog.
But for some private projects it is still an advantage to simplify starting and stopping containers from your your mobile phone.

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan [@stefscherer](https://twitter.com/stefscherer)
