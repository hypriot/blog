+++
Categories = ["Docker", "Swarm", "Vagrant", "Hypriot Cluster Lab"]
Tags = ["Docker", "Swarm", "Vagrant", "Hypriot Cluster Lab", "Cluster Lab", "Cluster", "Consul", "Virtualbox"]
date = "2016-03-10T23:00:00+01:00"
draft = false
more_link = "yes"
title = "Exciting Docker Swarm experiments in the Hypriot Cluster Lab"
+++

This post is - like the [last one](http://blog.hypriot.com/post/how-to-setup-rpi-docker-swarm/) - dedicated to the [Docker #SwarmWeek](https://blog.docker.com/2016/03/swarmweek-join-your-first-swarm/).

If you thought that it was pretty easy to set up a Swarm Cluster after our last post - you are going to be pretty surprised to find out that there is still room for improvement.

With our [Hypriot Cluster Lab](https://github.com/hypriot/cluster-lab) it is possible to get up a Swarm Cluster with just one command.
Follow along to learn how this is possible.

![Docker Swarm](/images/swarm-cluster-lab/cluster_lab.jpg)
<div style="text-align:right; font-size: smaller">Image courtesy of [SNRE Labs](https://www.flickr.com/photos/snre/10579433974/in/photolist-h7Sn93-4A4CPY-cr7gZ3-ySfs-Q2aKL-Q2GvM-akjGfr-6cX1D7-7Z4GYE-8XKoBo-82k2PZ-5J8yhX-7Sct35-h7SfKJ-h7SmSb-h7S44X-5J8y5a-4Y8HsH-p1Sz3h-4A4wom-4Bw54x-gQ23WX-iKWTQA-8D8m59-6PgZhg-8tKzAS-4kvY6K-9kaX8z-54x1BV-5xh7Sb-bLXPYZ-4zQ8mN-7KjCAt-MSdyd-qAw4Hw-awH1nc-4tKyxG-5wWtGU-4LMU7v-7NkBns-9a3pwX-h7Tuik-iAjqa-rvTgXa-h7S5uT-h7Shc1-qL7ofi-a18dLe-5RVXPz-8gLV)</div>

<!--more-->

The Hypriot Cluster Lab has already been there for while as an easy way to set up a Swarm Cluster on Raspberry Pi's.
The basic idea was to have a SD card image that can be used to boot up a couple of Pi's who then automatically form a Swarm Cluster.
As with any Lab the Cluster Lab provides a place to run all kind of experiments and gain new insights.

As part of our recent refactoring efforts to make the Cluster Lab more reliable we have been searching for ways to test the Cluster Lab as a whole.
The idea we came up was to use [Vagrant](https://www.vagrantup.com/) for our integration testing efforts.

Vagrant is a tool that makes it really easy to manage Virtual Machines. It allows us to describe a multi-machine setup in an easy to read text-based configuration file:

<script src="https://gist-it.appspot.com/github/hypriot/cluster-lab/raw/master/vagrant/Vagrantfile?slice=14:40&footer=minimal"></script>

One of the big advantages of Vagrant is that it is available for Mac, Linux and Windows users. This means that you can run the Cluster Lab on all those operating systems, too.

To get started with the Hypriot Cluster Lab you need to ensure that you have a recent version of Vagrant installed.
If not you can download it [here](https://www.vagrantup.com/downloads.html). Under the hood Vagrant uses a so-called provider to run the virtual machines.
For the Cluster Lab the recommended way is to use [VirtualBox](https://www.virtualbox.org/). Make sure it is already there or download and install it.

The next step is to clone the Hypriot Cluster Lab repository like this:

```
$ git clone https://github.com/hypriot/cluster-lab.git
```

Afterwards change into the `cluster-lab/vagrant` folder:

```
$ cd cluster-lab/vagrant
```

And now comes the single command you need to boot up a whole working Swarm Cluster:

```
$ vagrant up --provider virtualbox --no-color
```

This command will create three virtual machines based on Ubuntu Wily, install a recent Docker Engine and install and configure the Cluster Lab.
As this command will download Ubuntu Wily and lots of other software, too, it might take while. Please be patient.

While the Cluster Lab is booting it will run a number of self-tests to ensure that it is working properly.
You should see output similar to the following:

```
Internet Connection
  [PASS]   eth1 exists
  [PASS]   eth1 has an ip address
  [PASS]   Internet is reachable
  [PASS]   DNS works

Networking
  [PASS]   eth1 exists
  [PASS]   vlan os package exists
  [PASS]   Avahi os package exists
  [PASS]   Avahi-utils os package exists
  [PASS]   Avahi process exists
  [PASS]   Avahi cluster-leader.service file is absent

Configure basic networking

Networking
  [PASS]   eth1.200 exists
  [PASS]   eth1.200 has correct IP from vlan network
  [PASS]   Cluster leader is reachable
  [PASS]   eth1.200 has exactly one IP
  [PASS]   eth1.200 has no local link address
  [PASS]   Avahi process exists
  [PASS]   Avahi is using eth1.200
  [PASS]   Avahi cluster-leader.service file exists

This node is Leader

DHCP is enabled

DNSmasq
  [PASS]   dnsmasq os package exists
  [PASS]   dnsmasq process exists
  [PASS]   /etc/dnsmasq.conf backup file is absent

Configure DNSmasq

DNSmasq
  [PASS]   dnsmasq process exists
  [PASS]   /etc/dnsmasq.conf backup file exists

Docker
  [PASS]   docker is installed
  [PASS]   Docker process exists
  [PASS]   /etc/default/docker backup file is absent

Configure Docker

Docker
  [PASS]   Docker is running
  [PASS]   Docker is configured to use Consul as key-value store
  [PASS]   Docker is configured to listen via tcp at port 2375
  [PASS]   Docker listens on 192.168.200.30 via tcp at port 2375 (Docker-Engine)

Consul
  [PASS]   Consul Docker image exists
  [PASS]   Consul Docker container is running
  [PASS]   Consul is listening on port 8300
  [PASS]   Consul is listening on port 8301
  [PASS]   Consul is listening on port 8302
  [PASS]   Consul is listening on port 8400
  [PASS]   Consul is listening on port 8500
  [PASS]   Consul is listening on port 8600
  [PASS]   Consul API works
  [PASS]   Cluster-Node is pingable with IP 192.168.200.30
  [PASS]   Cluster-Node is pingable with IP 192.168.200.45
  [PASS]   Cluster-Node is pingable with IP 192.168.200.1
  [PASS]   No Cluster-Node is in status 'failed'
  [PASS]   Consul is able to talk to Docker-Engine on port 7946 (Serf)

Swarm
  [PASS]   Swarm-Join Docker container is running
  [PASS]   Swarm-Manage Docker container is running
  [PASS]   Number of Swarm and Consul nodes is equal which means our cluster is healthy
```

If everything worked all tests should be [PASS]ing.
In case that there were [FAIL]ing tests you can fix it with the help of our [troubleshooting](https://github.com/hypriot/cluster-lab#troubleshooting) guide.

The `vagrant up` command creates three cluster nodes called __leader__, __follower1__ and __follower2__.
To work with the Swarm Cluster we need to log into one of the cluster nodes and elevate ourself to root:

```
$ vagrant ssh leader
$ sudo su
```

We can use the Swarm Cluster by exporting the TCP address of the Swarm Cluster with the DOCKER_HOST environment variable:

```
$ export DOCKER_HOST=tcp://192.168.200.1:3278
```

Now all our Docker commands will work against the Swarm Cluster instead of the local Docker Engine.

Lets check if we really have a 3-Node-Swarm Cluster:
```
$ docker info
Containers: 9
 Running: 9
 Paused: 0
 Stopped: 0
Images: 6
Role: primary
Strategy: spread
Filters: health, port, dependency, affinity, constraint
Nodes: 3
 follower1: 192.168.200.46:2375
  └ Status: Healthy
  └ Containers: 3
  └ Reserved CPUs: 0 / 1
  └ Reserved Memory: 0 B / 1.018 GiB
  └ Labels: executiondriver=native-0.2, hypriot.arch=x86_64, hypriot.hierarchy=follower, kernelversion=4.2.0-30-generic, operatingsystem=Ubuntu 15.10, storagedriver=overlay
  └ Error: (none)
  └ UpdatedAt: 2016-03-10T21:24:07Z
 follower2: 192.168.200.44:2375
  └ Status: Healthy
  └ Containers: 3
  └ Reserved CPUs: 0 / 1
  └ Reserved Memory: 0 B / 1.018 GiB
  └ Labels: executiondriver=native-0.2, hypriot.arch=x86_64, hypriot.hierarchy=follower, kernelversion=4.2.0-30-generic, operatingsystem=Ubuntu 15.10, storagedriver=overlay
  └ Error: (none)
  └ UpdatedAt: 2016-03-10T21:24:35Z
 leader: 192.168.200.1:2375
  └ Status: Healthy
  └ Containers: 3
  └ Reserved CPUs: 0 / 1
  └ Reserved Memory: 0 B / 1.018 GiB
  └ Labels: executiondriver=native-0.2, hypriot.arch=x86_64, hypriot.hierarchy=leader, kernelversion=4.2.0-30-generic, operatingsystem=Ubuntu 15.10, storagedriver=overlay
  └ Error: (none)
  └ UpdatedAt: 2016-03-10T21:24:04Z
Plugins:
 Volume:
 Network:
Kernel Version: 4.2.0-30-generic
Operating System: linux
Architecture: amd64
CPUs: 3
Total Memory: 3.054 GiB
Name: 9c2606252982
```

As you can see we really have a working Swarm Cluster running.
That was easy, was it?

For more information about Docker Swarm you can follow the [#SwarmWeek: Introduction to container orchestration with Docker Swarm](https://blog.docker.com/2016/03/swarmweek-container-orchestration-docker-swarm/).

As always, use the comments below to give us feedback, discuss this post on [HackerNews](https://news.ycombinator.com/item?id=11263205) and share this post on Twitter, Google or Facebook.

Govinda [@_beagile__](https://twitter.com/_beagile_)
