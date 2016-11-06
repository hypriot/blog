+++
Categories = ["Docker", "High Availability", "Fault Tolerance", "Cluster","Raspberry Pi", "Cloud Computing"]
Tags = ["Docker", "High Availability", "Fault Tolerance", "Cluster","Raspberry Pi", "Cloud Computing"]
date = "2016-10-26T18:03:34+01:00"
more_link = "yes"
title = "Testing High Availability of Docker Swarm on a Raspberry Pi Cluster (Updated)"
+++

In its release in June this year, Docker announced two exciting news about the Docker Engine: First, the Engine 1.12 comes with built-in high availability features, called "Docker Swarm Mode". And second, Docker started providing official support for the ARM architecture.

These two news combined beg for testing the new capabilities in reality.

![SwarmClusterHA](/images/high-availability-testing/high-availability-docker-swarm.png)


<!--more-->

The "old" Docker Swarm already offered some high availability features, but the new called "Swarm Mode" goes far beyond: To me, the most important capabilities to mention are: built-in security, rolling updates and - maybe one of the most important benefits - super user-friendliness. Production ready clustering based on powerful container technology has probably never been easier before.

Also, the release of Docker 1.12 comes with official support for the ARM architecture. Running Docker on ARM has been possible for long time, but now, users can install it the same way on their Raspberry Pis as they do it on any other architecture: Using Docker's official repositories. If you are one of our regular readers, you know that our Team at Hypriot intensively collaborated with Docker to make this official support possible. So we are also very happy that this huge milestone that many people asked for is eventually checked!

Now, with these two news, let's get our hands dirty and test if the announced promises hold.


Setup the cluster
----------------------

**As hardware**, I have 5x Raspberry Pi 3, connected in a network with Internet access.

The Raspberry Pis with their SD cards, the network switch, power input and all cables live in a [hardware kit from PicoCluster](
https://www.picocluster.com/collections/starter-picocluster-kits/products/pico-5-raspberry-pi-starter-kit?variant=29344698892
). Thanks to PicoCluster for providing the kit to us for testing!

See how the cluster looks like:

![PicoClusterBuilt](/images/high-availability-testing/PicoCluster.jpg)

**As software**, I chose HypriotOS. I also tried Raspbian, but it requires a large system upgrade after the first boot in order to provide all features required by Docker (e.g. VXLAN kernel module). Before and after the system upgrade, I also had to run [Docker's test script]( https://github.com/docker/docker/blob/master/contrib/check-config.sh) to make sure everything is ok. All of this is not a big deal, but if there is an OS available that comes out of the box with all that Docker needs (and even adds lots of useful optimizations), it simply saves time and provides a hassle-free experience. So I flashed all SD cards with HypriotOS using our [flash tool](https://github.com/hypriot/flash).

**To connect to the cluster**, I SSHed into all the nodes via [Terminator](http://gnometerminator.blogspot.de/p/introduction.html). Terminator is my preferred tool to organize multiple terminals in a single window. It allows to send commands to several terminals at once. Soon, I'll have a look at tmux and might switch, but for now I recommend Terminator :)

Finally, we have 5 terminals opened, all waiting for commands as you see in the following image. Please don't care about the commands running in each terminal for now.

![Terminator](/images/high-availability-testing/terminal.png)

That's all to do before getting our hands on Docker itself!


Setup Docker Swarm on the cluster
--------------------------------

On latest HypriotOS, you'll have the latest Docker installed, so we can instantly start playing.

On an arbitrary node of the cluster, run
```
docker swarm init
```

The output should look similar to that:
```
Swarm initialized: current node (node-master) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-1acm9qa7b0hmzz5v8t40d75v5fsgckeu2z5ds6ls0x7cny7l8p-307wqrc8756akpxjxls9abbbs \
    [2a02:810d:8600:2a78:f6c6:d67d:6912:17ca]:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

```

As explained in this output, now you need to run the presented `docker swarm join ...` command on all other nodes, which you want to join the cluster.

Finally, on the node at which you executed `docker swarm init`, check if all nodes of your cluster successfully formed a swarm:

```
docker node ls
```

If the terminal prints a list of all nodes of your cluster, the setup is all done! Forming a cluster cannot be easier, can it?


Execution of tests
---------------------
My tests of Docker's ability to recover from failures comprise the following use cases:

  - The ethernet interface of a random node (master or slave) got unavailable
  - A random node completely rebooted
  - A random node instantly crashed (unplug power source)

I documented one of the test runs in the following screencast.

<div align="center">
<iframe src="https://player.vimeo.com/video/185361173" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
<p><a href="https://vimeo.com/185361173">Testing High Availability Docker Swarm Mode</a> from <a href="https://vimeo.com/user54109827">Mathias Renner</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
</div>

Results
------------
As shown in the screencast, Docker is able to recover from failure of the ethernet interface. After testing the other use cases later on, Docker recovered flawlessly from a reboot and crash as well. This holds for the slave and the master node, which is remarkable!

> **Edit on 6.11.2016**: Jérémy Derussé and Nikolay Kushin reported in the discussion below that for them a reboot or crash of a node did not result in a healthy cluster state after bringing up the node again. As of today, unfortunately I can confirm this, with Docker version 1.12.1, 1.12.2 as well as 1.12.3. I cannot explain why during my tests for this post a crashed node recovered smoothly.

> Based on Jeremy's report, I was able to create a quick fix for this issue. On a node, simply run:

>```
sudo crontab -e
```
Then insert this:

>```
@reboot docker ps
```
> Having this configured, after a crash or reboot the node recovered correctly in my tests. I look forward for feedback about this issue! Please use the discussion below.

More to come soon
------------------
This post is only a small chunk of the data I gathered during the tests. The next option to get the details is during my talk at the [HighLoad++ Conference](http://highload.co/) in Moskow, Russia. I'd be happy if you can make it there!

Also, this is not the end of the story of course. Thorough testing requires also measuring incoming requests from an external load tester to the cluster while a failure occurs. After some research, I have not found any evidence that someone has ever performed that tests (please correct me if I'm wrong!).

Moreover, Kubernetes received much attention lately since its support for ARM became better and better. So wouldn't it be interesting to see if Docker or Kubernetes is better in keeping a service available and performing well, even if there are outages in the cluster?

So there's more coming soon, just stay tuned for the upcoming posts :)

As always, use the comments below to give us feedback and share this post on Twitter, Google or Facebook.

[@MathiasRenner](https://twitter.com/MathiasRenner)
