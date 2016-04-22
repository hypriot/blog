+++
Categories = ["Docker", "Raspberry Pi", "ARM", "Docker Swarm", "Cluster"]
Tags = ["Docker", "Raspberry Pi", "ARM", "Docker Swarm", "Cluster"]
date = "2015-07-02T07:31:45+01:00"
title = "How to use Docker Swarm on your Raspberry Pi cluster"
more_link = "yes"
draft = true

galleryprefix = "/images"
galleryfolder = "docker-swarm"
gallerythumbnail = "thumbnails"
+++

In this blog post we show you how easy it is to install Swarm on your Raspberry Pi and how to setup a Raspberry Pi Swarm cluster with the help of Docker Machine.

We've built a little "Pi Tower" with three Raspberry Pi 2 model B and combine them into a Docker Swarm.
<!--more-->

As you can see in the pictures below we've mounted the three Raspberry Pi's on top of a 5-port D-Link GBit switch. All four devices get their power from an Anker 4-port USB charger. This makes a very solid but portable "Pi Tower" with only one power plug and one external network connector.

{{< gallery title="Pi Tower" >}}
{{% galleryimage file="d-link_mounting_holes.jpg" size="1600x1200" caption="The Making of Pi Tower" copyrightHolder="Hypriot" %}}
{{% galleryimage file="d-link_rpi2_cluster.jpg" size="1600x1200" caption="Pi Tower with D-Link Switch" copyrightHolder="Hypriot" %}}
{{% galleryimage file="d-link_rpi2_cluster02.jpg" size="1600x1200" caption="Pi Tower with D-Link Switch" copyrightHolder="Hypriot" %}}
{{% galleryimage file="d-link_rpi2_cluster_lights.jpg" size="1600x1200" caption="Pi Tower at night" copyrightHolder="Hypriot" %}}
{{< /gallery >}}

{{% galleryinit %}}


## Pre-requisites

For this tutorial we just run all steps from a Mac (or Linux) notebook. To do this we need three tools.

* A flash tool to write the SD card images for all the Raspberry Pi's.
* The Docker client, which is only a `brew install docker` away.
* The Docker Machine binary with the hypriot driver

## Flash all SD cards

First we want to install the SD cards with Docker preinstalled. On a Mac or Linux machine, we use our little [flash command line tool](https://github.com/hypriot/flash) to prepare the three SD cards with these simple commands.

```bash
$ flash --hostname pi1 http://downloads.hypriot.com/hypriot-rpi-20150416-201537.img.zip
$ flash --hostname pi2 http://downloads.hypriot.com/hypriot-rpi-20150416-201537.img.zip
$ flash --hostname pi3 http://downloads.hypriot.com/hypriot-rpi-20150416-201537.img.zip
```

Now insert the SD cards into all Raspberry Pi's and boot them. They will come up with different host names after a while.

## Retrieve IP addresses

Our SD card image also starts the avahi-daemon to announce the hostname through mDNS, so each Pi is reachable with `pi1.local`, `pi2.local` and `pi3.local`.
Docker Machine cannot resolve these hostnames at the moment, so we have to retrieve the IP addresses for the Raspberry Pi's.

```bash
$ ping -c 1 pi1.local
$ ping -c 1 pi2.local
$ ping -c 1 pi3.local
```

For this example we assume that the three IP adresses are `192.168.1.101`, `102` and `103`.

## Insert SSH public key

Docker Machine connects to each Raspberry Pi through SSH. You have to insert your public
SSH key to avoid entering the password of the `root` user. To insert the SSH public key into a remote machine there is a tool `ssh-copy-id`

```bash
$ ssh-copy-id root@192.168.1.101
$ ssh-copy-id root@192.168.1.102
$ ssh-copy-id root@192.168.1.103
```

For each of the Raspberry Pi's you have to enter the password `hypriot` for the user `root`.

## Create Docker Machines

For the next step we use our Docker Machine driver to connect to the Raspberry Pi Hypriot devices.
Our hypriot driver is not yet integrated into the official Docker Machine binary.
So we have to download the `docker-machine` binary with our hypriot machine driver.

```bash
$ curl -o docker-machine http://downloads.hypriot.com/docker-machine_0.4.0-dev_darwin-amd64
$ chmod +x ./docker-machine
```

We download the binary into the current directory and make it executable. You may move it
into another directory in your PATH to use it from other directories.

### Create Swarm Token

A Docker Swarm cluster uses a unique Cluster ID to enable all swarm agents find each other. We need such a Cluster ID to build our Docker Swarm. This can be done in your shell with this command

```bash
$ export TOKEN=$(for i in $(seq 1 32); do echo -n $(echo "obase=16; $(($RANDOM % 16))" | bc); done; echo)
$ echo $TOKEN
```

For this example we use

```bash
$ export TOKEN=babb1eb00bdecadedec0debabb1eb00b
```

If you already have a Docker swarm container up and running, you also can create a new Cluster ID
with `docker run --rm hypriot/rpi-swarm create`. We simply used the shell commands above to skip this chicken or the egg problem.

### Create the Swarm Master

Now we create the Docker Swarm Master on the first Raspberry Pi with our generated Cluster ID

```bash
$ ./docker-machine create -d hypriot --swarm --swarm-master --swarm-discovery token://$TOKEN --hypriot-ip-address 192.168.1.101 pi1
```

This command connects to the Raspberry Pi, secures the Docker daemon with TLS and pulls the Docker image `hypriot/rpi-swarm:latest` from the Docker Hub. It starts both the Swarm Master as well as a Swarm Agent in a container.

To check it we can connect to the newly started Swarm Master by using the following command that retrieves all environment variables needed for the Docker client to communicate with the Swarm.

```bash
$ eval $(./docker-machine env --swarm pi1)
$ docker info
Containers: 2
Strategy: spread
Filters: affinity, health, constraint, port, dependency
Nodes: 1
 pi1: 192.168.1.202:2376
  └ Containers: 2
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 971.3 MiB
```

We now have a Swarm Manager running alone. So let's start some more Raspberry Pi's to build a bigger swarm.

### Create the Swarm agents

For the rest of the Raspberry Pi's we also create Docker Machine connections with the same Cluster ID. This time we run docker-machine without the `--swarm-master` option to just spin up a Swarm Agent container in each Pi.

```bash
$ ./docker-machine create -d hypriot --swarm --swarm-discovery token://$TOKEN --hypriot-ip-address 192.168.1.102 pi2
$ ./docker-machine create -d hypriot --swarm --swarm-discovery token://$TOKEN --hypriot-ip-address 192.168.1.103 pi3
```

Let's check what the swarm looks like now

```bash
$ docker info
Containers: 4
Strategy: spread
Filters: affinity, health, constraint, port, dependency
Nodes: 3
 pi1: 192.168.1.101:2376
  └ Containers: 2
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 971.3 MiB
 pi2: 192.168.1.102:2376
  └ Containers: 1
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 971.3 MiB
 pi3: 192.168.1.103:2376
  └ Containers: 1
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 971.3 MiB
```

We also can list all containers in the whole swarm as usual with

```bash
$ docker ps
CONTAINER ID        IMAGE                      COMMAND                CREATED             STATUS              PORTS                                    NAMES
5effaa7de4a3        hypriot/rpi-swarm:latest   "/swarm join --addr    2 minutes ago       Up About a minute   2375/tcp                                 pi3/swarm-agent
6b73003b7246        hypriot/rpi-swarm:latest   "/swarm join --addr    4 minutes ago       Up 3 minutes        2375/tcp                                 pi2/swarm-agent
5e00fbf7b9f6        hypriot/rpi-swarm:latest   "/swarm join --addr    7 minutes ago       Up 7 minutes        2375/tcp                                 pi1/swarm-agent
02c905ec25a0        hypriot/rpi-swarm:latest   "/swarm manage --tls   7 minutes ago       Up 7 minutes        2375/tcp, 192.168.1.101:3376->3376/tcp   pi1/swarm-agent-master
```

After setting up the Docker Swarm you now can use the normal Docker commands through the port 3376. Have a look at the [official Docker Swarm documentation](https://docs.docker.com/swarm/) for more details.

Just remember to set the environments to communicate with the Swarm Master before using the Docker client.

```bash
$ eval $(docker-machine env --swarm pi1)
```

And then you can remotely manage your Raspberry Pi Swarm from your Mac or Linux machine.

We hope you enjoyed this little tour of Docker Swarm!

As always use the comments below to give us feedback and share it on Twitter or Facebook.

Stefan
