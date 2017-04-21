+++
Categories = ["Docker", "Raspberry Pi", "ARM", "DockerCon 2017"]
Tags = ["Docker", "Raspberry Pi", "ARM", "DockerCon"]
Description = "DockerCon 2017 Demo: Monitoring Docker Swarm with LED's"
aliases = [ "dockercon" ]
date = "2017-04-20T14:30:34-06:00"
more_link = "yes"
title = "DockerCon 2017 Demo: Monitoring Docker Swarm with LED's"
disqus = "yes"
social_sharing = "yes"

+++
At DockerCon 2017 in Austin I gave a presentation of a Raspberry Pi cluster mixed with some UP boards. The audience really liked the visual effects of the Docker Swarm scaling a service up and down. So I show you some background details what you need to run that demo on your Raspberry Pi cluster as well.

![PiCloud at DockerCon Austin](/images/dockercon2017/stage2.jpg)

<!--more-->

All the effort played off to build that cluster, to find out how to drive LED's in swarm mode, to put it into my bag and go through customs on my flight from Germany to Austin, Texas. It really was fun to show this the audience and everybody liked it.

To enable you to replay the demo with some Pimoroni Blinkt! LED's and Raspberry Pi - regardless if you only have Pi Zeros I want to show you the Docker images I used and the commands to show the scaling demo.

The Docker image [stefanscherer/monitor](https://hub.docker.com/r/stefanscherer/monitor/) is available on the Docker Hub. It is a multi-architecture image that can be used on Linux with Intel or ARM CPU's.

So just create a Docker swarm with the usual commands `docker swarm init` and then join some other workers with the swarm token shown in your terminal.

## Start the LED monitor

First we have to start the LED monitor as a service so that it is running on each node of the Docker swarm. The option `--mode global` will do this and start one instance on each node. We have to bind mount both the Docker socket and a part of the file system into the container so it can access the `/sys/class/fs` file system.

```bash
docker service create --name monitor --mode global \
  --restart-condition any --mount type=bind,src=/sys,dst=/sys \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  stefanscherer/monitor:1.1.0
```

Now we are all set to play with scaling an example service.

## Scale up

There is another multi-arch image that I used for the scaling demo. It is the "whoami" web service that responds the container's hostname.

First we create the service with

```bash
docker service create --name whoami stefanscherer/whoami:1.1.0
```

As said this works with any Raspberry Pi or the UP board that has an Intel Atom CPU.
After the image has been downloaded the LED monitor should show one yellow LED lighting up.

Now scale the service a little more eg. to the number of nodes you have to have one LED lighting up per node.

```bash
docker service scale whoami=4
```

Then scale it up a little more


```bash
docker service scale whoami=16
```

![Scale up](/images/dockercon2017/scale-up.gif)

And then light up all the LED's by scaling up to the number of LED's you have.

```bash
docker service scale whoami=32
```

## Rolling update

Another thing that can be visualized is a rolling update. The LED monitor shows each container with a yellow color for version 1.1.0 of the service and blue for version 1.2.0.

So start the rolling update by specifing `--update-parallelism` with the number of containers that should be replaced in one step. So Docker Swarm kills that number of containers and starts the new version of it before stopping the next bulk of containers. Use the `--image` option to specifiy the new version that should be used by the whoami service.

```bash
docker service update --update-parallelism 5 \
  --image stefanscherer/whoami:1.2.0 whoami
```

Now watch what happens. Each destroyed container lights up red and then dims. After a while Docker swarm manager starts the new version and so new LED's with blue light up. After a while all LED's have changed from yellow (version 1.1.0) to blue (version 1.2.0). And while this rolling update is going on you still can use this "whoami" service by curl'ing it.

![Rolling update](/images/dockercon2017/rolling-update.gif)

## Scale down to one

Another nice effect is to scale down the service back to one as all LED's will flash up in red and only one LED remains blue.

```bash
docker service scale whoami=1
```

![Scale down to one](/images/dockercon2017/scale-down-to-one.gif)

Hope I did make you curious to try it out on your own cluster. Happy hacking and have fun! If you want to improve the visual effects have a look at the Node.js sources in the [GitHub repo](https://github.com/StefanScherer/swarm-monitor). Rewrite it in Golang or anything else and suprise me with other nice visual effects.

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan [@stefscherer](https://twitter.com/stefscherer)
