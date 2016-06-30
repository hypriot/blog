+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM", "Docker Swarm", "1.12", "Swarm Mode"]
date = "2016-06-21T13:49:00+02:00"
draft = false
more_link = "yes"
title = "Swarm Machines or Having fun with Docker Machine and the new Docker Swarm orchestration"
+++

In the last couple of days there were some users on our Gitter channel having problems accessing their Raspberry Pi's with HypriotOS via Docker Machine.
As we have not yet written how that works I thought I would do a short blog post on how to use Docker Machine with HypriotOS.

But that's not all. Yesterday when I watched the DockerCon Keynote Livestream of the new Docker orchestration I wondered how Docker Machine and the new orchestration would work together.

So just for the fun of it I decided I will explore that a bit, too.

![Docker Swarm](/images/docker-machine/swarm_machines.jpg)
<div style="text-align:right; font-size: smaller">Image courtesy of [Brent M](https://www.flickr.com/photos/thewakingdragon/)</div>

<!--more-->

I am using the latest Docker4Mac with Docker on my notebook and three Raspberry Pi's with HypriotOS 0.8 as hosts for my remote Docker Engines.

The Docker version on the notebook and on the Pi's is 1.12 RC1. Having the lastest Docker 1.12 is not necessary for the part about Docker Machine, but it is for the part about the new Docker orchestration.

## Docker Machine
[Docker Machine](https://docs.docker.com/machine/) is used to control remote Docker-Engines as if they were locally installed. 

That is very convenient in many cases, for instance if you have set up a Docker host with the help of Amazon AWS or Microsoft Azure and you can access it only remotely.
In that case you do not have to establish a SSH connection first in order to work with a specific Docker Engine.

But that's not all - Docker Machine also helps if there is no Docker-Engine present on a remote host. 

With the help of Docker Machine it is very easy to install and configure a new Docker Engine. 

Both in case of an existing or a new Docker Engine Docker Machine reconfigures the Engine to make it availabe via a HTTP network socket.
To ensure that only authorized clients can connect to the remote Docker Engine Docker Machine also sets up everything that is needed for [securing the communication with TLS](https://docs.docker.com/engine/security/https/).

To remotely manage my Pi's with Docker Machine I first need to copy my SSH public key to the remote host. 
If you do not have a SSH key pair you need to [generate one first](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#generating-a-new-ssh-key).

Transfering your public key to a remote host is easily done with:

```
$ ssh-copy-id pirate@pi3.local
```

This command configures the remote host 'pi3.local' in a way that I can access this host via SSH with my default SSH key (~/.ssh/id_rsa).

We can test this now by executing:

```
$ ssh pirate@pi3.local ls -lah
total 32K
drwxr-xr-x 3 pirate pirate 4.0K Jun 21 12:01 .
drwxr-xr-x 3 root   root   4.0K May 17 22:43 ..
-rw------- 1 pirate pirate  116 Jun 21 12:01 .bash_history
-rw-r--r-- 1 pirate pirate  220 Oct 18  2014 .bash_logout
-rw-r--r-- 1 pirate pirate 2.5K May 17 22:42 .bash_prompt
-rw-r--r-- 1 pirate pirate  570 May 17 22:42 .bashrc
-rw-r--r-- 1 pirate pirate  314 May 17 22:42 .profile
drwx------ 2 pirate pirate 4.0K Jun 21 12:09 .ssh
```

This command establishes a SSH connection to the host 'pi3.local' and executes 'ls -lah'. If you can see a similar output everything is OK.

Next we need to add our 'pi3.local' host to the list of hosts that are managed by Docker Machine.

Let's see if we already have some existing hosts that are managed by Docker Machine.

```
$ docker-machine ls
NAME   ACTIVE   DRIVER    STATE     URL                          SWARM   DOCKER        ERRORS
pi1    -        generic   Running   tcp://192.168.178.171:2376           v1.12.0-rc1
pi2    -        generic   Running   tcp://192.168.178.24:2376            v1.12.0-rc1
```

And indeed we have two hosts that are already managed by Docker Machine.

Adding another one is easy:

```
$ docker-machine create --driver generic --generic-ip-address=192.168.178.59 --generic-ssh-key=/Users/govindaf/.ssh/id_rsa --generic-ssh-user=pirate --engine-storage-driver=overlay pi3
Running pre-create checks...
Creating machine...
(pi3) Importing SSH key...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with debian...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env pi3
```

The output looks good. Let's dissect this command a bit to understand what it does.

We are using the 'create' subcommand of Docker Machine to create a new host that is managed by Docker Machine.
We are also using the 'generic' driver that allows us to communicate with our Raspberry Pi's via SSH. 

For this we need to tell Docker Machine some SSH connection details like the IP address of our target host, the SSH user and the location of our private SSH key.

The IP address of our Pi can be easily obtained by running

```
$ ping -c1 pi3.local
PING pi3.local (192.168.178.59): 56 data bytes
64 bytes from 192.168.178.59: icmp_seq=0 ttl=64 time=1.926 ms

--- pi3.local ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.926/1.926/1.926/0.000 ms
```

It is important that we provide the absolute path to our private SSH key with the option 'generic-ssh-key'. A relative path did not work for me.

Furthermore we need to tell Docker Machine which user it should use for the SSH connection.
The default here is the 'root' user. With HypriotOS we can only use an unprivileged user which is why we need to provide the 'generic-ssh-user' option.

Last but no least we need to tell Machine to use the 'overlay' filesystem for the configuration of the Docker Engine which is the default with HypriotOS.
Without this option Docker Machine would try to use 'aufs' which would fail miserably.

Alright, let's see if we now have a third host under our Machine control:

```
$ docker-machine ls
NAME   ACTIVE   DRIVER    STATE     URL                          SWARM   DOCKER        ERRORS
pi1    -        generic   Running   tcp://192.168.178.171:2376           v1.12.0-rc1
pi3    -        generic   Running   tcp://192.168.178.59:2376            v1.12.0-rc1
pi2    -        generic   Running   tcp://192.168.178.24:2376            v1.12.0-rc1
```

Yeah - we do.

Sometimes you might get SSH timeout errors when setting up another host with Docker-Machine. 
If this is the case make sure you did not forget to set up your SSH public key with the remote host first.

Sometimes when Docker Machine tries to add a new host it happens that it is stuck halfway with an error.
In those cases the best course of action is often to remove the host first and add it again later.

```
$ docker-machine rm pi3
```

Let's assume all went well and we now have a list of host under remote control. How do you work with those now?

That's were the Docker Machine 'env' subcommand comes into play.

```
$ docker-machine env pi3
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.178.59:2376"
export DOCKER_CERT_PATH="/Users/govindaf/.docker/machine/machines/pi3"
export DOCKER_MACHINE_NAME="pi3"
# Run this command to configure your shell:
# eval $(docker-machine env pi3)
```

The env command outputs a bunch of environment variables that control to which Docker instance our local Docker binary is talking to.
Per default the 'docker' command only talks to our local Docker Engine - for instance on our notebook - but by exporting those environment variables this changes fundamentally.

The easiest way to export the necessary variables is by running:

```
$ eval $(docker-machine env pi3)
```

Now everything I do with the 'docker' command runs against the Docker Engine of my 'pi3' host.

Let's check if that is true:

```
$ docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 27
Server Version: 1.12.0-rc1
Storage Driver: overlay
 Backing Filesystem: extfs
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge null host overlay
Swarm: inactive
Runtimes: default
Default Runtime: default
Security Options:
Kernel Version: 4.4.10-hypriotos-v7+
Operating System: Raspbian GNU/Linux 8 (jessie)
OSType: linux
Architecture: armv7l
CPUs: 4
Total Memory: 925.4 MiB
Name: pi3
ID: 5DYT:MHTS:4JQK:KNGB:FYZI:EFG4:YIPZ:2WJR:VW5Y:KLPJ:WXCX:S3CG
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No cpuset support
Labels:
 provider=generic
Insecure Registries:
 127.0.0.0/8
 ```

As you can see with the 'Name' attribute, we are really working on host 'pi3'.

Changing to another host is also easy. 

Just repeat the command from above and replace the hostname with another:

```
$ eval $(docker-machine env pi2)
```

## Docker Machine and Docker Swarm Mode

In the past Docker Machine allowed to set up a Docker Swarm cluster with a [number of options](https://docs.docker.com/machine/reference/create/) for the 'create' subcommand.

With Docker 1.12 we now how a much more powerful version of Swarm that is directly integrated into Docker.
This feature is called Docker Swarm Mode and you can find some inital documentation about it [here](https://docs.docker.com/engine/swarm/).

I could not find any specifics on how to use it together with Docker Machine. So there might be better ways of how to deal with it than what I am going to show you now.

Assuming we have three fresh hosts that are managed by Docker Machine, we need to tell Docker to initialize a new Swarm cluster first.

We can execute the necessary command on any of our hosts.

```
$ eval $(docker-machine env pi1)
$ docker swarm init
```

This command create a Docker Swarm cluster with one node. This first node automatically becomes a Swarm Manager Node.

The output of 'docker info' shows us what role our current Docker Engine plays in regard to Swarm:

```
$ docker info
...
Swarm: active
 NodeID: efyap0lxrttld19djs3ygtuac
 IsManager: Yes
 Managers: 1
 Nodes: 1
 CACertHash: sha256:9a29dafb3f6f600b64e8ec7a421fd6386f938de623a3a479ca56229b22a6b680
...
```

There is also another command that is able to show us which nodes are part of our Swarm cluster:

```
$ docker node ls
ID                           NAME  MEMBERSHIP  STATUS  AVAILABILITY  MANAGER STATUS
efyap0lxrttld19djs3ygtuac *  pi1   Accepted    Ready   Active        Leader
```

OK. Time to add two more nodes.

First we need to switch our Docker environment with Docker Machine. Afterwards we join the existing Swarm cluster with the next node.

```
$ eval $(docker-machine env pi2)
$ docker swarm join pi1:2377
This node joined a Swarm as a worker.
```

Looks promising. Let's see what our 'docker node ls' command has to say:

```
$ docker node ls
Error response from daemon: this node is not participating as a Swarm manager
```

What's that?

Obviously we are only able to use the 'node' subcommand from a Swarm Manager node and not from a Swarm Worker node. 
So ignoring this for the moment let's add the last node, too.

```
$ eval $(docker-machine env pi3)
$ docker swarm join pi1:2377
This node joined a Swarm as a worker.
```

Let's switch back to our original Swarm Manager node:

```
$ eval $(docker-machine env pi1)
$ docker node ls
ID                           NAME  MEMBERSHIP  STATUS  AVAILABILITY  MANAGER STATUS
3cgg9qfo6nk77zisgrst1333n    pi2   Accepted    Ready   Active
6lezwd8vplgcdmxyhswbc1cvp    pi3   Accepted    Ready   Active
efyap0lxrttld19djs3ygtuac *  pi1   Accepted    Ready   Active        Leader
```

As you can see we have sucessfully set up a Docker Swarm Cluster with three nodes.

With the help of Docker Machine this was really easy and straightforward as we only had to switch our Docker environment to work on individual nodes.

So as a last treat for you and to be able to show another screenshot let's start a small webserver in our Swarm cluster:

```
$ docker service create --name hypriot-httpd -p 8080:80 --replicas 6 hypriot/rpi-busybox-httpd
```

This command creates a Docker Swarm service that consists of six running httpd containers that are spread equally across the three nodes of our Swarm cluster.

Seeing is believing so let's check this again by using the 'docker service task' sub sub command:

```
$ docker service tasks hypriot-httpd
ID                         NAME             SERVICE        IMAGE                      LAST STATE         DESIRED STATE  NODE
14ywlwfix019b95oizce0hgd2  hypriot-httpd.1  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi1
60k55m336zq04rke696m848w1  hypriot-httpd.2  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi3
55sl8zwi1v8om3pvtb0zscf8d  hypriot-httpd.3  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi2
105gbhovh5p3zmwpqaeg3hprd  hypriot-httpd.4  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi3
8her9l13z78g9mjdrkovs9d46  hypriot-httpd.5  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi2
5xwwxuvbwsr7pmomg91cnf08y  hypriot-httpd.6  hypriot-httpd  hypriot/rpi-busybox-httpd  Running 6 minutes  Running        pi1
```

On a Mac we now can open the website that is served by this service with:

```
$ open http://$(docker-machine ip pi1):8080
```

We are then rewarded with this neat little website:

![Docker Swarm](/images/docker-machine/hypriot-http.jpg)

Hope this tour was fun and gave you a feeling for the power that comes with Docker Machine.

As always use the comments below to give us feedback and share the news about this release on Twitter, Facebook or Google+.

Govinda [@_beagile__](https://twitter.com/_beagile_)
