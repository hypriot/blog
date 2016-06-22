+++
Categories = ["Docker", "Raspberry Pi", "ARM"]
Tags = ["Docker", "Raspberry Pi", "ARM", "Docker Compose", "Docker Swarm", "1.12", "microservices"]
date = "2016-06-20T21:49:00+02:00"
draft = false
more_link = "yes"
title = "More Microservices Bliss with Docker 1.12 and Swarm only"
+++

A couple of days ago I wrote a [blog post](http://blog.hypriot.com/post/microservices-bliss-with-docker-and-traefik/) about how easy it is to get a microservice application up and running with Docker and a HTTP proxy called Traefik.
I explained how awesome Traefik is because it makes complex setups with HAProxy, Registrator, Consul, etc. a thing of the past. 

I really thought it couldn't get much easier. Oh boy - was I wrong!

Today as part of the Docker opening keynote Docker demostrated an evolution of Docker Swarm that simplifies this whole scenario even more.
It makes setting up a Docker Swarm Cluster a really simple and straigtforward task.

Let's see how this new thing works...

![Docker Swarm](/images/more-microservices/swarm.jpg)
<div style="text-align:right; font-size: smaller">Image courtesy of [Brent M](https://www.flickr.com/photos/thewakingdragon/)</div>

<!--more-->

If you remember the example from my last post - it consisted of a microservice application made of a frontend and a couple of backend services.
The frontend was a Traefik HTTP proxy that routed the requests to the backend services.
And the backend for the sake of simplicity was just a simple Go-based HTTP webserver that returned the ID of the containers it was running within.

![Traffic](/images/traefik/microsservice_example_end.jpg)

The new Docker Swarm removes the need for a separate HTTP proxy in front of our application containers. 
The architecture from above is now slimmed down considerably and looks like this:

![With Swarm](/images/more-microservices/architecture_with_swarm.jpg)

Less moving parts - that is great!


Still we get built-in loadbalancing to our backend services. We even can access those services from every node in our cluster.
Docker Swarm has a kind of built-in mesh routing integrated that takes care of routing requests to the appropriate backend containers.

With all the new functionality one could assume that setting up a Docker Swarm cluster got even more complicated than before.
But to the contrary - it got much easier - and that by leaps and bounds.

Don't believe me? Just follow along.

As you might have guessed, we are doing this on Raspberry Pi cluster again.
I am using a homegrown version of Docker 1.12 that I installed on my Raspberry Pi. 
Hopefully when Docker 1.12 is not a release candidate anymore we will have a version for you ready, too.

Let's see what we have:

```
root@pi6 $ docker version
Client:
 Version:      1.12.0-rc1
 API version:  1.24
 Go version:   go1.6.2
 Git commit:   1f136c1-unsupported
 Built:        Wed Jun 15 15:35:51 2016
 OS/Arch:      linux/arm

Server:
 Version:      1.12.0-rc1
 API version:  1.24
 Go version:   go1.6.2
 Git commit:   1f136c1-unsupported
 Built:        Wed Jun 15 15:35:51 2016
 OS/Arch:      linux/arm
 ```

Great. Docker 1.12 RC1 is ready. We should have everything we need to get started.

Let's see if we can find out if we have same new features hidden in our Docker CLI.

```
root@pi6 $ docker
Usage: docker [OPTIONS] COMMAND [arg...]
       docker [ --help | -v | --version ]

A self-sufficient runtime for containers.
    ...
    service   Manage Docker services
    ...
    stats     Display a live stream of container(s) resource usage statistics
    ...
    swarm     Manage Docker Swarm
    ...
    update    Update configuration of one or more containers

Run 'docker COMMAND --help' for more information on a command.
```

I removed the lines of the command output that have not changed compared to the previous release. What remains though is still pretty interesting...

We now seem to have a 'docker swarm' command.

Let's see what it is all about...

```
root@pi6 $ docker swarm

Usage:  docker swarm COMMAND

Manage Docker Swarm

Options:
      --help   Print usage

Commands:
  init        Initialize a Swarm.
  join        Join a Swarm as a node and/or manager.
  update      update the Swarm.
  leave       Leave a Swarm.
  inspect     Inspect the Swarm

Run 'docker swarm COMMAND --help' for more information on a command.
```

So 'Initialize a Swarm.' seems to be exactly what we want. Let's start with this one.

```
root@pi6 $ docker swarm init
Swarm initialized: current node (1njlvzi9rk2syv3xojw217o0g) is now a manager.
```

Now that we have a Swarm manger node running it is time to add some more nodes to the cluster.  
And it is really simple as well.

Just go to another node of your cluster and execute:

```
root@pi1 $ docker swarm join pi6:2377
This node joined a Swarm as a worker.
```

With this command we basically just tell new nodes that they should join the Swarm Manager node on which we created the inital Swarm cluster.
In the background Docker Swarm now does some work for us. 

For instance it sets up encrypted communication channels between the cluster nodes. We do not need to manage TLS certificates on our own.

Everybody who knows how involved it could be to get a Docker Swarm cluster up running in the past should realize how easy it is now.

Still we are not yet finished.

A 'docker info' on our Swarm Manager node reveals some interesting tidbits.
Again I removed the uninteresting parts for brevity.

```
root@pi6 $ docker info
...
Swarm: active
 NodeID: 1njlvzi9rk2syv3xojw217o0g
 IsManager: Yes
 Managers: 1
 Nodes: 2
 CACertHash: sha256:de4e2bff3b63700aad01df97bbe0397f131aabed5fabb7732283f044472323fc
...
Kernel Version: 4.4.10-hypriotos-v7+
Operating System: Raspbian GNU/Linux 8 (jessie)
OSType: linux
Architecture: armv7l
CPUs: 4
Total Memory: 925.4 MiB
Name: pi6
...
```

As you can see we now have a new 'Swarm' part in the 'docker info' output.
It tells us that our current node is a Swarm Manager node and that the cluster is composed of two cluster nodes in total.

On our second node it looks a bit different as it is not a Manager node:

```
Swarm: active
 NodeID: 3fmwt4taurwxczr2icboojz8g
 IsManager: No
```

Until now we just have an interesting, but still very empty Swarm cluster. 
Let's change that.

Before we start let me introduce you to the concept of a service that is also new abstraction with Docker 1.12. 
You might have seen a hint of it already in the output of the Docker command above.
Yes, it is the 'docker service' command that I am talking about.
A Docker service is basically just a bit of software running in a container that offers its 'service' to the outside world and runs on a Swarm cluster. 

Such a service can consist of just one container or of multiple containers. 
In the latter case we get high availability and/or loadbalancing for our service out of the box.

Let's create such a service based on our 'whoami' image from my last blog post.

```
root@pi6 $ docker service create --name whoami -p 80:8000 hypriot/rpi-whoami
buy0q65lw7nshm76kvy5imxk3
```

With the help of the 'docker swarm ls' command we can check the status of our new service.

```
root@pi6 $ docker service ls
ID            NAME    SCALE  IMAGE               COMMAND
buy0q65lw7ns  whoami  1      hypriot/rpi-whoami
```

Let's check if we can request the index page from our whoami container by sending I http request via curl to the ip of eth0 network interface.

```
root@pi6 $ curl http://192.168.178.24
I'm 1b6df814c654
```

And it is working. Awesome!

Those who followed along with keen eyes will have noticed the 'SCALE' part in the header line of the 'docker swarm ls' command.
It seems as we can scale our service somehow.

```
root@pi6 $ docker service scale whoami=5
whoami scaled to 5
```

OK. Let's check what we have now:

```
root@pi6 $ docker service ls
ID            NAME    SCALE  IMAGE               COMMAND
buy0q65lw7ns  whoami  5      hypriot/rpi-whoami

root@pi6 $ for i in {1..5}; do curl http://192.168.178.24; done
I'm 8db1657e8517
I'm e1863a2be88d
I'm 1b6df814c654
I'm 8db1657e8517
I'm e1863a2be88d
```

This is pretty neat. 

But this is not just way more simple than the old Swarm, it also feels much more snappier and faster when executing commands.
And remember I am working on Raspberry Pi's and not on a beefy server like you would propably work on.

Let's see how this looks from the perspective of an individual Docker engine.

```
root@pi6 $ docker ps
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS               NAMES
e1863a2be88d        hypriot/rpi-whoami:latest   "/http"             2 minutes ago       Up 2 minutes        8000/tcp            whoami.4.0lg12zndbal72exqe08r9wvpg
8db1657e8517        hypriot/rpi-whoami:latest   "/http"             2 minutes ago       Up 2 minutes        8000/tcp            whoami.5.5z6mvsrdy73m5w24icgsqc8i2
1b6df814c654        hypriot/rpi-whoami:latest   "/http"             8 minutes ago       Up 8 minutes        8000/tcp            whoami.1.bg4qlpiye6h6uxyf8cmkwuh52
```

As you can see from the five containers that were started three reside on 'pi6'.

Let's see if we can find the rest:

```
root@pi1 docker ps
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS               NAMES
db411a119c0a        hypriot/rpi-whoami:latest   "/http"             6 minutes ago       Up 6 minutes        8000/tcp            whoami.2.2tf7yhmx9haol7e2b7xib2emj
0a4bf32fa9c4        hypriot/rpi-whoami:latest   "/http"             6 minutes ago       Up 6 minutes        8000/tcp            whoami.3.2r6mm091c2ybr0f9jz4qaxw9k
```

So what happens when I just leave the Swarm cluster on 'pi1'?

```
root@pi1 docker swarm leave
Node left the default swarm.
```

Now I should be two containers short, right?

Let's see what we have on our remaining node:

```
docker ps
CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS               NAMES
58620e3d533c        hypriot/rpi-whoami:latest   "/http"             46 seconds ago      Up 43 seconds       8000/tcp            whoami.2.cgc4e2ixulc2f3ehr4laoursg
acc9b523f434        hypriot/rpi-whoami:latest   "/http"             46 seconds ago      Up 43 seconds       8000/tcp            whoami.3.67bhlo3nwgehthi3bg5bfdzue
e1863a2be88d        hypriot/rpi-whoami:latest   "/http"             8 minutes ago       Up 8 minutes        8000/tcp            whoami.4.0lg12zndbal72exqe08r9wvpg
8db1657e8517        hypriot/rpi-whoami:latest   "/http"             8 minutes ago       Up 8 minutes        8000/tcp            whoami.5.5z6mvsrdy73m5w24icgsqc8i2
1b6df814c654        hypriot/rpi-whoami:latest   "/http"             15 minutes ago      Up 14 minutes       8000/tcp            whoami.1.bg4qlpiye6h6uxyf8cmkwuh52
```

What we witnessed here is the same what would have happened if we just had a failing 'pi1' node.
All the containers that were running on node 'pi1' were migrated to the remaining cluster nodes automatically.
That's pretty impressive.

So to recap what we just did:  
We created a small dynamic microservice applications with just the plain Docker. 
Docker Swarm is now integrated into the Docker-Engine instead of being a separate piece of software. 
In many cases this makes a separate proxy for the backend services of your application obsolete. No more nginx, HAProxy or Traefik. Sorry to see you go... 

Despite having fewer moving parts we now have additional load balancing and high availability features built-in. 
I am really looking forward to find out what else there is in store with the new Docker Swarm and how it works together with Docker Compose.

But that's a story for another day...

As always use the comments below to give us feedback and share the news about this release on Twitter, Facebook or Google+.

Govinda [@_beagile__](https://twitter.com/_beagile_)
