+++
Categories = ["Docker", "High Availability", "Fault Tolerance", "Cluster","Raspberry Pi", "Cloud Computing"]
Tags = ["Docker", "High Availability", "Fault Tolerance", "Cluster","Raspberry Pi", "Cloud Computing"]
date = "2016-06-06T18:03:34+01:00"
more_link = "yes"
title = "Testing High Availability of Docker on a Raspberry Pi Cluster"
+++

In its release in June this year, Docker announced two exciting news about its Docker Engine: First, the Engine 1.12 comes with built-in high availability features, called "Docker Swarm Mode". And second, Docker started providing official support for the ARM architecture.

These two news combined beg for testing these new capabilities in reality. Let's see if it really works!

![TODO](/images/high-availability-testing/TODO)


<!--more-->

Even if the "old" Docker Swarm also offered some similar features, the new called "Swarm Mode" goes far beyond: To me, the most important capabilities to mention are: built-in security, rolling updates and - maybe one of the most important benefits - super user-friendliness. Production ready clustering based on powerful container technology has probably never been easier before.

Also, the release of Docker 1.12 comes with official support for the ARM architecture. Running Docker on ARM has been possible for long time, but now, users can install it the same way on their Raspberry Pis as they do it on any other architecture: Using Docker's official repositories. If you are one of our regular readers, you know that our Team at Hypriot intensively collaborated with Docker to make this official support possible. So we are also very happy that this huge milestone that many people asked for is eventually checked!

Now, with these two news, let's get our hands dirty and test if the announced promises hold.


Setup the cluster
------------
**As hardware**, I have 5x Raspberry Pi 3, connected in a network with Internet access.

The Raspberry Pis with their SD cards, the network switch, power input and all cables live in a [hardware kit from PicoCluster](
https://www.picocluster.com/collections/starter-picocluster-kits/products/pico-5-raspberry-pi-starter-kit?variant=29344698892
). Thanks to PicoCluster for providing the kit to us for testing!

This is how the cluster looks like:
![PicoClusterBuilt](/images/high-availability-testing/PicoCluster.jpg)

**As software**, I chose HypriotOS. I also tried Raspbian, but it requires a large system upgrade after the first boot in order to provide all features required by Docker (e.g. VXLAN kernel module). Before and after the system upgrade, I also had to run [Docker's test script]( https://github.com/docker/docker/blob/master/contrib/check-config.sh) to make sure everything is ok. All of this is not a big deal, but if there is an OS available that comes out of the box with all Docker needs, it saves time and provides a hassle-free experience. So I flashed all SD cards with HypriotOS using our [flash tool](https://github.com/hypriot/flash).

**To connect to the cluster**, I SSHed into all the nodes via [Terminator](http://gnometerminator.blogspot.de/p/introduction.html). Terminator is my preferred tool to organize multiple terminals in a single window. It allows to send commands to several terminals at once (soon, I'll have a look at tmux and might switch :) )

Finally, we have 5 terminals opened, all waiting for commands:

![Terminator](/images/high-availability-testing/terminal.png)

That's it! Let's get our Hands on Docker now.


Setup Docker Swarm in no time
----------------------
On latest HypriotOS, you'll have the latest Docker installed, so we can instantly start playing.

On an arbitrary node of the cluster, run
```
docker swarm init
```

Then, on all other nodes, run what the output of the previous command suggested.

Finally, on the node at which you executed `docker swarm init`, check if all nodes of your cluster successfully formed a swarm:

```
docker node ls
```

If the terminal prints a list of all nodes of your cluster, the setup is all done! Forming a cluster cannot be easier, can it?


Execution of tests
-----------

My tests of Docker's ability to recover from failures comprised the following use cases:
- the ethernet interface of a random node (master or slave) got unavailable
- a random node completely rebooted
- a random node instantly crashed (unplug power source)


I documented a test run in the following screencast. The screencast covers only the first use case of the list above, but Docker behaves the same for all other use cases.

<iframe src="https://player.vimeo.com/video/185361173" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
<p><a href="https://vimeo.com/185361173">Testing High Availability Docker Swarm Mode</a> from <a href="https://vimeo.com/user54109827">Mathias Renner</a> on <a href="https://vimeo.com">Vimeo</a>.</p>


Results
------------
As shown in the screencast, Docker is able to recover from failure. Even a failure of the master node is handled by Docker flawlessly. I think that this is really awesome!

More to come soon
----
Of course, this is not the end of the story. Thorough testing requires also to measuring incoming requests when a failure occurs. After some research, I have not found any evidence that someone has ever performed that tests. Also, Kubernetes received much attention lately since its support for ARM became better and better. So stay tuned for the next blog post :)

Also this post is only a small chunk of the data I gathered during the tests. The next option to get the details is during my talk at the [HighLoad++ Conference](http://highload.co/) in Moskow, Russia.

As always, use the comments below to give us feedback and share this post on Twitter, Google or Facebook.

[@MathiasRenner](https://twitter.com/MathiasRenner)
